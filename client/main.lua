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
end

function JSC:Start()
	if not self or not self.Config or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end
	local txd = CreateRuntimeTxd(self.Config.TextureDict)
	for i = 1, 2 do CreateRuntimeTextureFromImage(txd, tostring(i), "LockPart" .. i .. ".PNG") end

	self.MinigameOpen = true
	self.SoundID 	  = GetSoundId() 
	self.Timer 		  = GetGameTimer()

	if not IsRadarHidden() then self.JUtils.SetUI(false); end
	if not RequestAmbientAudioBank(self.Config.AudioBank, false) then self.JUtils.LoadAudioBank(self.Config.AudioBankName); end
	if not HasStreamedTextureDictLoaded(self.Config.TextureDict) then self.JUtils.LoadTextureDict(self.Config.TextureDict); end

	Citizen.CreateThread(function(...) self:Update(...); end)	
end

function JSC:Update()
	if not self or not self.Config or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end 
	Citizen.CreateThread(function(...) self:HandleMinigame(...); end)
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
    elseif 	IsControlPressed( 0, self.JUtils.Keys[ 'LEFTSHIFT' ] ) 	then rotSpeed 	=   1.0; modifier = 50; 
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

function JSC:HandleMinigame() 
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

		if 		correctCount > 1 and 	correctCount < 5 and lockVal + (self.Config.LockTolerance * 3.60) < lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] < lockNumbers[correctCount] then self:EndMinigame(false)
		elseif 	correctCount > 1 and 	correctCount < 5 and lockVal - (self.Config.LockTolerance * 3.60) > lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] > lockNumbers[correctCount] then self:EndMinigame(false)
		elseif 	correctCount > 4 then 	self:EndMinigame(true)
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

function JSC:EndMinigame(won)	
	if not self or not self.Config or not self.MinigameOpen or not ESX or not self.ESX or not JUtils or not self.JUtils then return; end

	self.MinigameOpen = false	
	if IsRadarHidden() then self.JUtils.SetUI(true); end

	local msg = ""
	if won then 
		PlaySoundFrontend(self.SoundID, 	self.Config.SafeFinalSound, self.Config.SafeSoundset, true)
		msg = "~g~You cracked the lock."; Citizen.Wait(1000)
		PlaySoundFrontend(self.SoundID,  self.Config.SafeOpenSound, 	self.Config.SafeSoundset, true)
		TriggerServerEvent('JSC:AddReward')
	else		
		PlaySoundFrontend(self.SoundID, 	self.Config.SafeResetSound, self.Config.SafeSoundset, true)
		msg = "~r~You didn't crack the lock."
	end

	TriggerEvent('esx:showNotification', msg)
end

function JSC:SpawnObjectTable(table, position, heading)
	if not table or not position or not heading or type(table) ~= 'table' or type(position) ~= 'vector3' or type(heading) ~= 'number' then return; end

	self.JUtils.LoadModelsInTable(self.SafeModels)

	for k,v in pairs(table) do
		local hash = self.JUtils.GetHashKey(v.ModelName)
		local newObj = CreateObject(hash, v.Pos.x + position.x, v.Pos.y + position.y, v.Pos.z + position.z, true, false, true)
		FreezeEntityPosition(newObj, true)
		if v.Rot.x ~= 0.0 or v.Rot.y ~= 0.0 or v.Rot.x ~= 0.0 then SetEntityRotation(newObj, v.Rot.x, v.Rot.y, v.Rot.z, 1, true); end
		if v.Heading ~= 0.0 then SetEntityHeading(newObj, heading + v.Heading); end
	end
end

Citizen.CreateThread(function(...) JSC:Awake(...); end)