Gangs = {}
GangsFnc = {} 
TriggerServerEvent("plouffe_gangs:sendConfig")

RegisterNetEvent("plouffe_gangs:getConfig",function(list)
	if list == nil then
		CreateThread(function()
			while true do
				Wait(0)
				Gangs = nil
				GangsFnc = nil
			end
		end)
	else
		Gangs = list
		GangsFnc:Start()
	end
end)