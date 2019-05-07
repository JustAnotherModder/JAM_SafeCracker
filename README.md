# JAM_SafeCracker

- No support, don't post an issue. Only simple questions that the example below doesn't already answer.
- This release should probably be considered, at this point, "for developers only".

JAM_SafeCracker is being used with another mod that I'm developing, so it isn't very modular. In order to use this, you're going to need to modify a few things, and come up with your own "reward scheme", ect.

- JAM_SafeCracker_Server.lua -- function JSC:AddReward
- JAM_SafeCracker_Client.lua -- function JSC:EndMinigame

^^ Both contain things you're going to have to change.

Some information on how I'm using the safecracker:
```
JAM_Drugs.Zones.MethLab.Positions.SafePos = vector3( 1012.10, -3194.40, -39.1 )
JAM_Drugs.Zones.MethLab.Positions.SafeActionPos	= vector3( 1012.15, -3195.35, -40.0 )

JAM_Drugs.Zones.MethLab.SafeRewards	= { 
	WeaponAmount 	= 1,
	DrugsAmount 	= 75,
	CashAmount 		= 7500,

	Items = { 'jammeth', 'jamcocaine' },	
		
	Weapons = { 
		"WEAPON_HEAVYPISTOL", "WEAPON_PISTOL50", "WEAPON_SMG", "WEAPON_ASSAULTSMG", "WEAPON_REVOLVER", 
		"WEAPON_PUMPSHOTGUN", "WEAPON_ASSAULTRIFLE", "WEAPON_SMG", "WEAPON_REVOLVER", "WEAPON_COMBATMG", 
		"WEAPON_COMPACTRIFLE", "WEAPON_ASSAULTSHOTGUN", "WEAPON_SPECIALCARBINE", "WEAPON_ADVANCEDRIFLE",
		"WEAPON_SAWNOFFSHOTGUN", "WEAPON_HEAVYSHOTGUN", "WEAPON_MG",
	},				
}

function JAM_Drugs:LoadSafe(zone)
	self.SpawnedObjs = self.SpawnedObjs or {}
    local safePos = zone.Positions.SafePos
    local safeObj = JSC:SpawnSafeObject(JSC.SafeObjects, safePos, 0.0)
    for k,v in pairs(safeObj) do table.insert(self.SpawnedObjs, v); end
end

TriggerEvent('JAM_SafeCracker:StartMinigame', zone.SafeRewards)
```

![alt text](https://i.imgur.com/2FvhMqS.jpg)

### Requirements
* [EssentialMode](https://github.com/kanersps/essentialmode/releases)
* [EssentialMode Extended](https://github.com/ESX-Org/es_extended)
* [JAM-Base](https://github.com/JustAnotherModder/JAM)
## Download & Installation

### Manually
- Download https://github.com/JustAnotherModder/JAM_SafeCracker/archive/master.zip
- Extract the JAM_SafeCracker folder (and its contents) into your `JAM` folder, inside of your `resources` directory.
- Open `__resource.lua` in your `JAM` folder.
- Add the files to their respective locations, like so :

```
client_scripts {
	'JAM_Main.lua',
	'JAM_Client.lua',
	'JAM_Utilities.lua',

	-- SafeCracker
	'JAM_SafeCracker/JAM_SafeCracker_Config.lua',
	'JAM_SafeCracker/JAM_SafeCracker_Client.lua',
}

server_scripts {	
	'JAM_Main.lua',
	'JAM_Server.lua',
	'JAM_Utilities.lua',

	-- MySQL
	'@mysql-async/lib/MySQL.lua',

	-- SafeCracker
	'JAM_SafeCracker/JAM_SafeCracker_Config.lua',
	'JAM_SafeCracker/JAM_SafeCracker_Server.lua',
}
```

### Notes
- Any and all improvements must be send back to the author (me), here on github.
