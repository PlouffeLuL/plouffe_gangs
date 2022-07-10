function GangsFnc:Init()
    TriggerEvent('ooc_core:getCore', function(value) 
        Utils = value 

        MySQL.query('SELECT * FROM gangs', {}, function(gangs)
            for k,v in pairs(gangs) do
                Gangs.GangInfo[v.name] = {
                    name = v.name,
                    label = v.label,
                    grades = {}
                }
            end

            MySQL.query('SELECT * FROM gangs_grade', {}, function(gangsRanks)
                for k,v in pairs(gangsRanks) do
                    if Gangs.GangInfo[v.club_name] then
                        Gangs.GangInfo[v.club_name].grades[tostring(v.grade)] = v
                    end
                end

                for k,v in pairs(Gangs.GangInfo) do
                    if Utils:GetArrayLength(v.grades) <= 0 then
                        Gangs.GangInfo[v.name] = nil
                    end
                end

                for k,v in pairs(Gangs.GangInfo) do
                    Server.PlayersPerGang[k] = {}
                end
            
                for k,v in pairs(GetPlayers()) do
                    local xPlayer = exports.ooc_core:getPlayerFromId(v)
                    if xPlayer then
                        Server.PlayersPerGang[xPlayer.gang.name][v] = {grade = xPlayer.gang.grade}
                    end
                end

                for k,v in pairs(Gangs.Gangs) do
                    for x,y in pairs(v.coordsList) do
                        if x:find("inventory") then
                            local groups = {}

                            if type(y.groups[1]) == "string" then
                                groups[y.groups[1]] = 0
                            elseif type(y.groups) == "table" and not y.groups[1] then
                                for group,grades in pairs(y.groups) do
                                    local lowestGrade = 100

                                    for grade,bool in pairs(grades) do
                                        if tonumber(grade) and tonumber(grade) < lowestGrade then
                                            lowestGrade = tonumber(grade)
                                        end
                                    end

                                    groups[group] = lowestGrade
                                end
                            end

                            exports.ox_inventory:RegisterStash(x, "Inventaire", 100, 100000, nil, groups, x.coords)
                        end
                    end
                end

                Server.Init = true

                Utils = nil
            end) 
        end)
    end, "Utils")
end

function GangsFnc:Notify(playerId,type,txt,length)
    if not type then type = "inform" end
    if not length then length = 5000 end
    if not txt or not playerId then return end
    TriggerClientEvent('plouffe_lib:notify', playerId, { type = type, text = txt, length = length})
end

function GangsFnc:HasAcces(xPlayer,index)
    if type(xPlayer) ~= "table" then
        xPlayer = exports.ooc_core:getPlayerFromId(xPlayer)
    end

    if type(Gangs.Gangs[xPlayer.gang.name].coordsList[index].groups[1]) == "string" then 
        return true
    elseif type(Gangs.Gangs[xPlayer.gang.name].coordsList[index].groups[xPlayer.gang.name]) == "table" then
        if Gangs.Gangs[xPlayer.gang.name].coordsList[index].groups[xPlayer.gang.name][tostring(xPlayer.gang.grade)] then
            return true
        end
    end

    return false
end

function GangsFnc:OpenInventory(playerId,index)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    if self:HasAcces(xPlayer,index) then
        local stash = { name = index, slots = 100, coords = Gangs.Gangs[xPlayer.gang.name].coordsList[index].coords }
        exports.ooc_core:OpenStash(playerId, {id = stash, slots = stash.slots, type = 'stash'})
    end
end

function GangsFnc:ChangePlayerGrade(playerId,employeInfo,gradeInfo)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    if Gangs.Gangs[xPlayer.gang.name].bossAccess[tostring(xPlayer.gang.grade)] then
        if xPlayer.gang.grade > gradeInfo.grade then  
            local xTarget = exports.ooc_core:getPlayerFromStateId(employeInfo.state_id)
            local str = "Vous avez %s %s au grade de %s"

            if xTarget and xTarget.gang.name == xPlayer.gang.name then
                if xTarget.gang.grade > gradeInfo.grade then
                    xTarget.setGang(xTarget.gang.name,gradeInfo.grade)
                    self:Notify(playerId,"success",str:format("rétrograder",employeInfo.name,gradeInfo.label))
                elseif xTarget.gang.grade < gradeInfo.grade then
                    xTarget.setGang(xTarget.gang.name,gradeInfo.grade)
                    self:Notify(playerId,"success",str:format("promu",employeInfo.name,gradeInfo.label))
                else
                    self:Notify(playerId,"error","Vous n'etes pas autoriser a faire cela")
                end
            else
                MySQL.query("SELECT gang_grade, gang FROM users_characters WHERE state_id = :state_id",{
                    ["state_id"] = employeInfo.state_id
                }, function(res)
                    if res[1] and (res[1].gang == xPlayer.gang.name) then
                        if res[1].gang_grade > gradeInfo.grade then
                            self:UpdateOffLinePlayerGang(employeInfo.state_id,res[1].gang,gradeInfo.grade,function(result)
                                self:Notify(playerId,"success",str:format("rétrograder",employeInfo.name,gradeInfo.label))     
                            end)
                        elseif res[1].gang_grade < gradeInfo.grade then
                            self:UpdateOffLinePlayerGang(employeInfo.state_id,res[1].gang,gradeInfo.grade,function(result)
                                self:Notify(playerId,"success",str:format("promu",employeInfo.name,gradeInfo.label))
                            end)
                        else
                            self:Notify(playerId,"error","Vous n'etes pas autoriser a faire cela")
                        end
                    else
                        self:Notify(playerId,"error","Impossible de trouver cette personne")
                    end
                end)
            end
        else
            self:Notify(playerId,"error","Vous ne pouvez pas promouvoir quelqun a un grade plus haut que le votre ou équale au votre")
        end
    end
end

function GangsFnc:UpdateOffLinePlayerGang(state_id,gang,grade,cb)
    MySQL.query("UPDATE users_characters SET gang_grade = :gang_grade, gang = :gang WHERE state_id = :state_id",{
        ["state_id"] = state_id,
        ["gang_grade"] = grade,
        ["gang"] = gang
    }, function(penis)
        cb(penis)
    end)
end

function GangsFnc:FirePlayer(playerId,employeInfo)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)

    if Gangs.Gangs[xPlayer.gang.name].bossAccess[tostring(xPlayer.gang.grade)] then
        local xTarget = exports.ooc_core:getPlayerFromStateId(employeInfo.state_id)
        
        if xTarget then
            xTarget.setGang("none",0)
            self:Notify(playerId,"success",("Vous avez mis %s a la porte"):format(employeInfo.name))  
        else
            self:UpdateOffLinePlayerGang(employeInfo.state_id,"none",0,function(result)
                self:Notify(playerId,"success",("Vous avez mis %s a la porte"):format(employeInfo.name))  
            end)
        end

    end
end

function GangsFnc:RecruteNew(playerId,targetId,gradeInfo)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)

    if Gangs.Gangs[xPlayer.gang.name].bossAccess[tostring(xPlayer.gang.grade)] then
        local xTarget = exports.ooc_core:getPlayerFromId(targetId)
        if xTarget then
            xTarget.setGang(xPlayer.gang.name,gradeInfo.grade)
            self:Notify(playerId,"success",("Vous avez recruter %s au grade de %s"):format(xTarget.name, gradeInfo.label))  
        else
            self:Notify(playerId,"error","Impossible de trouver le joueur")
        end
    end
end

function GangsFnc:TriggerGangEvent(event,gang,grade,...)
    if Server.PlayersPerGang[gang] then
        for k,v in pairs(Server.PlayersPerGang[gang]) do
            if grade and (((type(grade) == "number" or type(grade) == "string") and tonumber(grade) == tonumber(v.grade)) or (type(grade) == "table" and (grade[tostring(v.grade)] or grade[tonumber(v.grade)]))) then
                TriggerClientEvent(event, k, ...)
            elseif not grade then
                TriggerClientEvent(event, k, ...)
            end
        end
    end
end

function TriggerGangEvent(event,gang,grade,...)
    GangsFnc:TriggerJobEvent(event,gang,grade,...)
end

function GetPlayersPerGang(gang)
    return gang and Server.PlayersPerGang[gang] or Server.PlayersPerGang
end