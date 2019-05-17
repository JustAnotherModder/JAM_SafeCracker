local JSC = JAM.SafeCracker

function JSC:AddReward(rewards)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return; end

	if rewards.CashAmount then xPlayer.addAccountMoney('black_money', rewards.CashAmount); end

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