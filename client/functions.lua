local Callback = exports.plouffe_lib:Get("Callback")
local Utils = exports.plouffe_lib:Get("Utils")
local Core = nil

function GangsFnc:Start()
    while not Core do
        TriggerEvent('ooc_core:getCore', function(core) Core = core end)
        Wait(1000)
    end

    while not Core.Player:IsPlayerLoaded() do
        Wait(500)
    end

    Gangs.Player = Core.Player:GetPlayerData()

    self:RegisterAllEvents()
    self:ActivateGangZones(Gangs.Player.gang.name)
end

function GangsFnc:ActivateGangZones(newGang,oldGang)
    if oldGang and Gangs.Gangs[oldGang] then
        if Gangs.Gangs[oldGang] then
            for k,v in pairs(Gangs.Gangs[oldGang].coordsList) do
                exports.plouffe_lib:DestroyZone(v.name)
            end
        end
    end
    if Gangs.Gangs[newGang] then 
        for k,v in pairs(Gangs.Gangs[newGang].coordsList) do
            exports.plouffe_lib:ValidateZoneData(v)
        end
    end
end

function GangsFnc:RegisterAllEvents()
    RegisterNetEvent('ooc_core:setgang', function(gang,oldGang)
        Gangs.Player.gang = gang
        self:ActivateGangZones(Gangs.Player.gang.name,oldGang.name)
    end)

    RegisterNetEvent("on_gangs_from_zones", function(params) 
        if self[params.fnc] then
            self[params.fnc](self,params)
        end
    end)
end

function GangsFnc:AlphabeticArray(a)
    local sortedArray = {}
    local indexArray = {}
    local elements = {}

    for k,v in pairs(a) do
        if v.label then
            sortedArray[v.label] = v
            table.insert(indexArray, v.label)
        end
    end

    table.sort(indexArray)

    for k,v in pairs(indexArray) do
        table.insert(elements, sortedArray[v])
    end

    return elements
end

function GangsFnc:GetGradeMenu(gradeList)
    local gradeArray = {}
    local ignore = {}
    local currentGrade = -1
    local id = 1
    repeat
        for k,v in pairs(gradeList) do
            if v.grade == currentGrade + 1 and not ignore[k] then
                id = id + 1
                table.insert(gradeArray,{
                    id = id,
                    header = v.label,
                    txt = "Choisir ce grade",
                    params = {
                        event = "",
                        args = v
                    }
                })
                ignore[k] = true
                break
            end
        end
        currentGrade = currentGrade + 1
        Wait(0)
    until Utils:GetArrayLength(gradeList) <= 0 or currentGrade > 10
    return gradeArray
end

function GangsFnc:HasGang(name,rank)
    if not name then
        return Gangs.Player.gang.name ~= "none"
    elseif name and not rank then
        return Gangs.Player.gang.name == name
    elseif name and Gangs.Player.gang.name == name and rank then
        if type(rank) == "table" then
            return rank[Gangs.Player.gang.grade] ~= nil
        else
            return tonumber(Gangs.Player.gang.grade) == tonumber(rank)
        end
    end
    return false
end

function GangsFnc:HasAcces(index)
    if type(Gangs.Gangs[Gangs.Player.gang.name].coordsList[index].groups[1]) == "string" then 
        return true
    elseif type(Gangs.Gangs[Gangs.Player.gang.name].coordsList[index].groups) == "table" then
        if Gangs.Gangs[Gangs.Player.gang.name].coordsList[index].groups[Gangs.Player.gang.name][tostring(Gangs.Player.gang.grade)] then
            return true
        end
    end
    return false
end

function GangsFnc:OpenWardrobe(params)
    if self:HasGang(params.gang) and self:HasAcces(params.index) then
        Core.Skin:OpenWardrobe()
    end
end

function GangsFnc:OpenInventory(params)
    if self:HasGang(params.gang) and self:HasAcces(params.index) then
        exports.ox_inventory:openInventory("stash", {id=params.index, type="stash"})
        -- TriggerServerEvent("plouffe_gangs:OpenInventory",params.index,Gangs.Utils.MyAuthKey)
    else
        Utils:Notify("Vous n'avez pas les accès néscéssaire","error")
    end
end

function GangsFnc:OpenBossMenu(params)
    if self:HasGang(params.gang) and self:HasAcces(params.index) then
        exports.ooc_menu:Open(Gangs.Menu.bossMenu,function(pinis)
            if not pinis then
                return
            end

            if self[pinis.fnc] then
                self[pinis.fnc](self,params,pinis)
            end
        end)
    else
        Utils:Notify("Vous n'avez pas les accès néscéssaire","error")
    end
end

function GangsFnc:EmployesMenu(params,info)
    if self:HasGang(params.gang) and self:HasAcces(params.index) then
        local members = Callback:Sync("plouffe_gangs:fetchmembers", params.index, Gangs.Utils.MyAuthKey)
        local menuData = {}

        for k,v in pairs(members) do
            v.label = ("%s %s"):format(v.firstname,v.lastname)
            v.name = ("%s %s"):format(v.firstname,v.lastname)
        end

        for k,v in ipairs(self:AlphabeticArray(members)) do
            table.insert(menuData,{
                id = k,
                header = v.label,
                txt = Gangs.GangInfo[Gangs.Player.gang.name].grades[tostring(v.gang_grade)].label..", cliquer pour modifier",
                params = {
                    event = "",
                    args = v
                }
            })
        end

        exports.ooc_menu:Open(menuData,function(userParams)
            if not userParams then
                return
            end

            self:OpenEmployeeSpecificMenu(userParams)
        end)
    else
        Utils:Notify("Vous n'avez pas les accès néscéssaire","error")
    end
end

function GangsFnc:OpenEmployeeSpecificMenu(userParams)
    local menuData = {
        {
            id = 1,
            header = ("%s %s"):format(userParams.firstname,userParams.lastname),
            txt = Gangs.GangInfo[Gangs.Player.gang.name].grades[tostring(userParams.gang_grade)].label,
            params = {
                event = "",
                args = {
                    fnc = "Anus"
                }
            }
        }
    }

    for k,v in ipairs(Gangs.Menu.member) do
        table.insert(menuData,v)
    end

    exports.ooc_menu:Open(menuData,function(params)
        if not params then
            return
        end

        if self[params.fnc] then
            self[params.fnc](self,userParams)
        end
    end)
end

function GangsFnc:ChangeMemberGrade(userParams)
    exports.ooc_menu:Open(self:GetGradeMenu(Gangs.GangInfo[Gangs.Player.gang.name].grades), function(gradeInfo)
        if not gradeInfo then
            return
        end

        TriggerServerEvent("plouffe_gangs:changerPlayerGrade",userParams,gradeInfo,Gangs.Utils.MyAuthKey)
    end)
end

function GangsFnc:KickOut(employeParams)
    local tempMenu = {
        {
            id = 1,
            header = ("Voulez vous vraiment retirer %s de votre gang"):format(employeParams.name),
            txt = "Appuyer sur 'Oui' pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "Oui",
            txt = "Confirmer",
            params = {
                event = "",
                args = {
                    validate = true
                }
            }
        },
        {
            id = 3,
            header = "Non",
            txt = "Annuler",
            params = {
                event = "",
                args = {
                }
            }
        }
    }

    exports.ooc_menu:Open(tempMenu, function(gradeParams)
        if not gradeParams then
            return
        end

        if gradeParams.validate then
            TriggerServerEvent("plouffe_gangs:fire_player",employeParams,Gangs.Utils.MyAuthKey)
        end
    end)
end

function GangsFnc:RecruitNew()
    local closestPlayer, distance = Utils:GetClosestPlayer()
    if closestPlayer ~= -1 and distance <= 2.0 then
        local name = GetPlayerName(closestPlayer)
        exports.ooc_menu:Open({
            {
                id = 1,
                header = ("Voulez vous vraiment recruter %s "):format(name),
                txt = "Selectioner 'Oui' pour comfirmer",
                params = {
                    event = "",
                    args = {
                    }
                }
            },
    
            {
                id = 2,
                header = "Oui",
                txt = ("Recruter %s"):format(name),
                params = {
                    event = "",
                    args = {
                        validate = true
                    }
                }
            },

            {
                id = 3,
                header = "Non",
                txt = "Fermer le menu",
                params = {
                    event = "",
                    args = {
                    }
                }
            }
    
        }, function(params)
            if not params then
                return
            end

            if params.validate then
                exports.ooc_menu:Open(self:GetGradeMenu(Gangs.GangInfo[Gangs.Player.gang.name].grades), function(gradeInfo)
                    if not gradeInfo then
                        return
                    end

                    TriggerServerEvent("plouffe_gangs:recrute",GetPlayerServerId(closestPlayer),gradeInfo,Gangs.Utils.MyAuthKey)
                end)
            end
        end)
    else
        Utils:Notify("Aucun joueur près","error",5000)
    end
end