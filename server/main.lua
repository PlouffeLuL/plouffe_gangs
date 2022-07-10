CreateThread(function()
    MySQL.ready(function()
        GangsFnc:Init()
    end)
end)

RegisterNetEvent("plouffe_gangs:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)
    
    while not Server.Init do
        Wait(100)
    end
    
    if registred then
        local cbArray = Gangs
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_gangs:getConfig",playerId,cbArray)
    else
        TriggerClientEvent("plouffe_gangs:getConfig",playerId,nil)
    end
end)

RegisterNetEvent("plouffe_gangs:OpenInventory",function(index,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) == true then
        if Auth:Events(playerId,"plouffe_gangs:OpenInventory") == true then
            GangsFnc:OpenInventory(playerId,index)
        end
    end
end)

RegisterNetEvent("plouffe_gangs:changerPlayerGrade",function(employeInfo,gradeInfo,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) == true then
        if Auth:Events(playerId,"plouffe_gangs:changerPlayerGrade") == true then
            GangsFnc:ChangePlayerGrade(playerId,employeInfo,gradeInfo)
        end
    end
end)

RegisterNetEvent("plouffe_gangs:fire_player",function(employeInfo,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) == true then
        if Auth:Events(playerId,"plouffe_gangs:fire_player") == true then
            GangsFnc:FirePlayer(playerId,employeInfo)
        end
    end
end)

RegisterNetEvent("plouffe_gangs:recrute",function(targetId,grade,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) == true then
        if Auth:Events(playerId,"plouffe_gangs:recrute") == true then
            GangsFnc:RecruteNew(playerId,targetId,grade)
        end
    end
end)

RegisterNetEvent("ooc_core:playerloaded", function(xPlayer)
    Server.PlayersPerGang[xPlayer.gang.name][xPlayer.playerId] = {grade = xPlayer.gang.grade}
end)

RegisterNetEvent('ooc_core:setgang', function(playerId, newGang, lastGang) 
    if Server.PlayersPerGang[lastGang.name][playerId] then
        Server.PlayersPerGang[lastGang.name][playerId] = nil
    end   

    Server.PlayersPerGang[newGang.name][playerId] = {grade = newGang.grade}
end)

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    for k,v in pairs(Server.PlayersPerGang) do
        if v[playerId] then
            v[playerId] = nil
            break
        end
    end
end)