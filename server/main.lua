JSC = JAM_SafeCracker
	
function JSC:GetESX(obj) self.ESX = obj; ESX = obj; end
function JSC:GetJUtils(obj) self.JUtils = obj; JUtils = obj; end

function JSC:Start()
	while not ESX or not self.ESX do
		TriggerEvent('esx:getSharedObject', function(...) self:GetESX(...); end)
		Citizen.Wait(0)
	end

	while  not JUtils or not self.JUtils do
		TriggerEvent('JAM_Utilities:GetSharedObject', function(...) self:GetJUtils(...); end)
		Citizen.Wait(0)
	end
end

RegisterNetEvent('JSC:Startup')
AddEventHandler('JSC:Startup', function() JSC:Start(); end)

function JSC:AddReward(rewards)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return; end

	if rewards.CashAmount then cashReward = xPlayer.addMoney(rewards.CashAmount); end

	for k,v in pairs(rewards.Items) do
		local randomCount = math.random(1, rewards.DrugsAmount)
		xPlayer.addInventoryItem(v, randomCount)
	end

	for i = 1, rewards.WeaponAmount do
		local randomWeapon = rewards.Weapons[math.random(1, #rewards.Weapons)]
		xPlayer.addWeapon(randomWeapon, math.random(50, 250))
	end
end

RegisterNetEvent('JSC:AddReward')
AddEventHandler('JSC:AddReward', function(rewards) JSC:AddReward(rewards); end)