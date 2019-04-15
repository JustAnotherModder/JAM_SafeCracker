JSC = JAM_SafeCracker

AddEventHandler('JAM_SafeCracker:GetSharedObject', function(cb) cb(JAM_SafeCracker); end)

function JSC:GetESX(obj) self.ESX = obj; ESX = obj; end
function JSC:GetJUtils(obj) self.JUtils = obj; JUtils = obj; end

function JSC:Awake()
	if not self then return; end	

	while not ESX or not self.ESX or not JUtils or not self.JUtils do
		TriggerEvent('esx:getSharedObject', 		  	function(...) self:GetESX(...); 	end)
		TriggerEvent('JAM_Utilities:GetSharedObject', 	function(...) self:GetJUtils(...); 	end)
		Citizen.Wait(0)
	end

	TriggerServerEvent('JSC:Startup')
end
	-- ignore this. of no relevance to anything.

	-- local playerpos = GetEntityCoords(PlayerPedId())
	-- local hashKey =GetHashKey("bkr_prop_biker_safebody_01a")
	-- local newObj = CreateObject(hashKey, playerpos.x, playerpos.y, playerpos.z, true, false, true)
	-- print(GetOffsetFromEntityGivenWorldCoords(newObj, playerpos.x, playerpos.y, playerpos.z))
	-- SetEntityHeading(newObj, 270.0)
	-- print(GetOffsetFromEntityGivenWorldCoords(newObj, playerpos.x, playerpos.y, playerpos.z))
	-- --print(GetModelDimensions(hashKey))


function JSC:StartMinigame(rewards)
	if not self or not self.Config or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end
	local txd = CreateRuntimeTxd(self.Config.TextureDict)
	for i = 1, 2 do CreateRuntimeTextureFromImage(txd, tostring(i), "LockPart" .. i .. ".PNG") end

	self.MinigameOpen = true
	self.SoundID 	  = GetSoundId() 
	self.Timer 		  = GetGameTimer()
	self.JUtils.SetUI(false)

	if not IsRadarHidden() then self.JUtils.SetUI(false); end
	if not RequestAmbientAudioBank(self.Config.AudioBank, false) then self.JUtils.LoadAudioBank(self.Config.AudioBankName); end
	if not HasStreamedTextureDictLoaded(self.Config.TextureDict) then self.JUtils.LoadTextureDict(self.Config.TextureDict); end

	Citizen.CreateThread(function() self:Update(rewards); end)	
end

RegisterNetEvent('JAM_SafeCracker:StartMinigame')
AddEventHandler('JAM_SafeCracker:StartMinigame', function(rewards) JSC:StartMinigame(rewards); end)

function JSC:Update(rewards)
	if not self or not self.Config or not self.MinigameOpen or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end	
	Citizen.CreateThread(function() self:HandleMinigame(rewards); end)
	while self.MinigameOpen do
		self:InputCheck()   
		Citizen.Wait(0)
	end
end

function JSC:InputCheck()
	if not self or not self.Config or not self.MinigameOpen or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end	
	local leftKeyPressed 	= IsControlPressed( 0, self.JUtils.Keys[ 'LEFT' ] ) 	or 0
	local rightKeyPressed 	= IsControlPressed( 0, self.JUtils.Keys[ 'RIGHT' ] )	or 0
	if 		IsControlPressed( 0, self.JUtils.Keys[ 'G' ] ) 			then self:EndMinigame(false); end
	if 		IsControlPressed( 0, self.JUtils.Keys[ 'Z' ] ) 			then rotSpeed 	=   0.1; modifier = 33;
    elseif 	IsControlPressed( 0, self.JUtils.Keys[ 'LEFTSHIFT' ] )	then rotSpeed 	=   1.0; modifier = 50; 
    else 																 rotSpeed	=   0.4; modifier = 90; end

    local lockRotation = math.max(modifier / rotSpeed, 0.1)

    if leftKeyPressed ~= 0 or rightKeyPressed ~= 0 then
    	self.LockRotation = self.LockRotation - ( rotSpeed * tonumber( leftKeyPressed ) )
    	self.LockRotation = self.LockRotation + ( rotSpeed * tonumber( rightKeyPressed ) )
    	if (GetGameTimer() - self.Timer) > lockRotation then 
    		PlaySoundFrontend(0, self.Config.SafeTurnSound, self.Config.SafeSoundset, false)
    		self.Timer = GetGameTimer() 
    	end
    end
end

function JSC:HandleMinigame(rewards) 
	if not self or not self.Config or not self.MinigameOpen or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end

	local lockRot 		 = math.random(385.00, 705.00)	

	local lockNumbers 	 = {}
	local correctGuesses = {}

	lockNumbers[1] = 1
	lockNumbers[2] = math.random(					 45.0, 					359.0)
	lockNumbers[3] = math.random(lockNumbers[2] -	719.0, lockNumbers[2] - 405.0)
	lockNumbers[4] = math.random(lockNumbers[3] +  	 45.0, lockNumbers[3] + 359.0)

	-----------------------
	-- REDO LOCK NUMBERS --
	-----------------------
	-- Make numbers persist if chosen.
	-- Add number count for difficulty.
	-- Multiples of 2 are positive, 45 - 359;
	-- Multiples of 3 are negative, 719 - 405;
	-- Everything else is negative, 45 - 359;

	---------------------------------------------
	-- Still havn't done, you're welcome to ^^ --
	---------------------------------------------

	--------------------------------------
	-- Comment this out for a challenge --
	--------------------------------------

	print("Here ya go, bloody cheater.")
	for i = 1,4 do
		print((lockNumbers[i] % 360) / 3.60)
	end

    local correctCount	= 1
    local hasRandomized	= false

    self.LockRotation = 0.0 + lockRot
								
	while self.MinigameOpen do	
		--				Texture Dictionary, Texture Name, xPos, yPos, xSize, ySize, 		   Heading,   R,   G,   B,   A,
		DrawSprite(self.Config.TextureDict, 		 "1",  0.8,  0.5,  0.15,  0.26, -self.LockRotation, 255, 255, 255, 255)
		DrawSprite(self.Config.TextureDict, 		 "2",  0.8,  0.5, 0.176, 0.306, 		      -0.0, 255, 255, 255, 255)	

		hasRandomized = true

		local lockVal = math.floor(self.LockRotation)

		if 		correctCount > 1 and 	correctCount < 5 and lockVal + (self.Config.LockTolerance * 3.60) < lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] < lockNumbers[correctCount] then self:EndMinigame(false, rewards); self.MinigameOpen = false; 
		elseif 	correctCount > 1 and 	correctCount < 5 and lockVal - (self.Config.LockTolerance * 3.60) > lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] > lockNumbers[correctCount] then self:EndMinigame(false, rewards); self.MinigameOpen = false; 
		elseif 	correctCount > 4 then 	self:EndMinigame(true, rewards)
		end

		for k,v in pairs(lockNumbers) do
		  	if not hasRandomized then self.LockRotation = lockRot; end
			if lockVal == v and correctCount == k then
				local canAdd = true
				for key,val in pairs(correctGuesses) do
					if val == lockVal and key == correctCount then
						canAdd = false
					end
				end

				if canAdd then 				
					PlaySoundFrontend(-1, self.Config.SafePinSound, self.Config.SafeSoundset, true)
					correctGuesses[correctCount] = lockVal
					correctCount = correctCount + 1; 
				end   				  			
			end
		end
		Citizen.Wait(0)
	end
end

function JSC:EndMinigame(won, rewards)
	if not self or not self.Config or not self.MinigameOpen or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end

	self.MinigameOpen = false	
	-- if IsRadarHidden() then self.JUtils.SetUI(true); end

	local msg = ""
	if won then 
		PlaySoundFrontend(self.SoundID, 	self.Config.SafeFinalSound, self.Config.SafeSoundset, true)
		msg = "~g~You cracked the lock."

		Citizen.Wait(100)

		PlaySoundFrontend(self.SoundID,  self.Config.SafeOpenSound, 	self.Config.SafeSoundset, true)
		TriggerServerEvent('JSC:AddReward', rewards)
		
		while self.DoorHeading + 150 > GetEntityHeading(self.DoorObj) do		
			SetEntityHeading(self.DoorObj, GetEntityHeading(self.DoorObj) + 0.3)
			Citizen.Wait(0)
		end
	else		
		PlaySoundFrontend(self.SoundID, 	self.Config.SafeResetSound, self.Config.SafeSoundset, true)
		msg = "~r~You didn't crack the lock."

	end

	TriggerEvent('esx:showNotification', msg)
end

RegisterNetEvent('JAM_SafeCracker:EndMinigame')
AddEventHandler('JAM_SafeCracker:EndMinigame', function(won, rewards) JSC:EndMinigame(won, rewards); end)

function JSC:SpawnSafeObject(table, position, heading)
	if not self or not JUtils then return; end
	if not table or not position or not heading then return; end
	if type(table) ~= 'table' or type(position) ~= 'vector3' or type(heading) ~= 'number' then return; end

	JUtils.LoadModelsInTable(self.SafeModels)

	local retTable = {}
	local i = 0
	for k,v in pairs(table) do
		i = i + 1
		local hash = JUtils.GetHashKey(v.ModelName)
		local newHeading = heading + v.Heading

		local newObj = CreateObject(hash, v.Pos.x + position.x, v.Pos.y + position.y, v.Pos.z + position.z, true, false, true)

		if v.ModelName == JSC.SafeModels.Door then 
			JSC.DoorObj = newObj
			JSC.DoorHeading = GetEntityHeading(self.DoorObj)
		end

		FreezeEntityPosition(newObj, true)
		SetEntityHeading(newObj, newHeading)

		if v.Rot.x ~= 0.0 or v.Rot.y ~= 0.0 or v.Rot.z ~= 0.0 then SetEntityRotation(newObj, v.Rot.x, v.Rot.y, v.Rot.z, 1, true); end
		retTable[v.ModelName] = newObj		
	end
	return retTable
end

Citizen.CreateThread(function(...) JSC:Awake(...); end)