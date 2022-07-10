Callback:RegisterServerCallback("plouffe_gangs:fetchmembers", function(source, cb, index, authkey)
    if Auth:Validate(source,authkey) and Auth:Events(source,"plouffe_gangs:fetchmembers") then
        local xPlayer = exports.ooc_core:getPlayerFromId(source)

        if GangsFnc:HasAcces(xPlayer,index) then
            MySQL.query("SELECT firstname, lastname, state_id, gang_grade FROM users_characters WHERE gang = @gang", {
                ["@gang"] = xPlayer.gang.name
            }, function(result)
                cb(result)
            end)
        else
            cb({})
        end
    end
end)