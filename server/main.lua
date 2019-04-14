JSC = JAM_SafeCracker

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)	

function JSC:AddReward(...)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return; end

	xPlayer.addMoney(self.Config.CashReward)	
end

RegisterNetEvent('JSC:AddReward')
AddEventHandler('JSC:AddReward', function(...) JSC:AddReward(...); end)