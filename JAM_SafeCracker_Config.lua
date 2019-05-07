JAM.SafeCracker = {}
local JSC = JAM.SafeCracker
JSC.ESX = JAM.ESX

JSC.Config = {
	LockTolerance	= 3,								-- How many clicks past the pin can the player go before the lock fails?							

	AudioBankName 	= "SAFE_CRACK",						
	TextureDict 	= "JSCTextureDict",

	SafeSoundset 	= "SAFE_CRACK_SOUNDSET",
	SafeTurnSound	= "tumbler_turn",
	SafePinSound	= "tumbler_pin_fall",
	SafeFinalSound	= "tumbler_pin_fall_final",
	SafeResetSound	= "tumbler_reset",
	SafeOpenSound	= "safe_door_open",
}

JSC.SafeModels = {
	Safe  	= "bkr_prop_biker_safebody_01a",
	Door  	= "bkr_prop_biker_safedoor_01a",

	CashA 	= "bkr_prop_moneypack_03a",
	CashB 	= "bkr_prop_bkr_cashpile_01",

	MethA 	= "bkr_prop_meth_openbag_01a",
	MethB 	= "bkr_prop_meth_openbag_02",
	MethC 	= "bkr_prop_meth_smallbag_01a",

	CokeA 	= "bkr_prop_coke_cutblock_01",

	WeedA 	= "bkr_prop_weed_bag_pile_01a",
	WeedB 	= "bkr_prop_weed_dry_01a",

	GunA  	= "ex_office_swag_guns01",
}

JSC.SafeObjects = {
	safeObj  = { ModelName = JSC.SafeModels.Safe,  Pos 	= vector3(   0.0,   0.0,   -0.1 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	doorObj  = { ModelName = JSC.SafeModels.Door,  Pos 	= vector3(   0.0,   0.0,    0.0 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = true  },

	cashAObj = { ModelName = JSC.SafeModels.CashA, Pos 	= vector3( -0.34,  0.34,    0.0 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cashBObj = { ModelName = JSC.SafeModels.CashA, Pos 	= vector3( -0.35,  0.35,   0.13 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },

	gunAObj  = { ModelName = JSC.SafeModels.GunA,  Pos 	= vector3( -0.16,  0.40,   0.22 ), Heading =  0.0,   Rot = vector3(-135.0, -90.0, -135.0), 			Frozen = false },
	weedAObj = { ModelName = JSC.SafeModels.WeedA, Pos 	= vector3( -0.45,  0.30,   0.75 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	weedBObj = { ModelName = JSC.SafeModels.WeedB, Pos 	= vector3( -0.35,  0.30,   0.75 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },

	methAObj = { ModelName = JSC.SafeModels.MethA, Pos 	= vector3( -0.45,  0.45,   0.26 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	methBObj = { ModelName = JSC.SafeModels.MethB, Pos 	= vector3( -0.25,  0.25,   0.26 ), Heading = 45.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	methCObj = { ModelName = JSC.SafeModels.MethB, Pos 	= vector3( -0.55,  0.50,   0.75 ), Heading = 25.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	methDObj = { ModelName = JSC.SafeModels.MethC, Pos 	= vector3( -0.55,  0.25,   0.75 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },

	cokeAObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.23,  0.45,   0.75 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeBObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.23,  0.45,   0.80 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeCObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.23,  0.45,   0.85 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeDObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.23,  0.45,   0.90 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },	
	cokeEObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.23,  0.45,   0.95 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeFObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.23,  0.45,   1.00 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeGObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.07,  0.45,   0.75 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },	
	cokeHObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.07,  0.45,   0.80 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0),			Frozen = false },
	cokeIObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.07,  0.45,   0.85 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeJObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.07,  0.45,   0.90 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeKObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.07,  0.45,   0.95 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
	cokeLObj = { ModelName = JSC.SafeModels.CokeA, Pos 	= vector3( -0.07,  0.45,   1.00 ), Heading =  0.0,   Rot = vector3(   0.0,   0.0,    0.0), 			Frozen = false },
}