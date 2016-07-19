/*
	nedbandit1 with new difficulty selection system
	Mission gives % chance of persistent vehicle
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
	based on work by Defent and eraser1
	Vehicle loading borrowed from Occupation Crate mission by second_coming
*/

private ["_num", "_side", "_pos", "_OK", "_difficulty", "_extraParams", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_wreck", "_crate", "_vehicle", "_vehicleP", "_pinCode", "_class", "_veh", "_crate_loot_values", "_veh", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_PossibleDifficulty", "_PossibleColour", "_colour", "_VehicleChance", "_Vwin", "_cash", "_ned_VehicleItems", "_item", "_itemType", "_amount", "_randomAmount", "_customGearSet", "_customGearSet2"];

// For logging purposes
_num = DMS_MissionCount;

// Set mission side
_side = "bandit";

// This part is unnecessary, but exists just as an example to format the parameters for "DMS_fnc_MissionParams" if you want to explicitly define the calling parameters for DMS_fnc_FindSafePos.
// It also allows anybody to modify the default calling parameters easily.
if ((isNil "_this") || {_this isEqualTo [] || {!(_this isEqualType [])}}) then
{
	_this =
	[
		[10,DMS_WaterNearBlacklist,DMS_MinSurfaceNormal,DMS_SpawnZoneNearBlacklist,DMS_TraderZoneNearBlacklist,DMS_MissionNearBlacklist,DMS_PlayerNearBlacklist,DMS_TerritoryNearBlacklist,DMS_ThrottleBlacklists],
		[
			[]
		],
		_this
	];
};

// Check calling parameters for manually defined mission position.
_OK = (_this call DMS_fnc_MissionParams) params
[
	["_pos",[],[[]],[3],[],[],[]],
	["_extraParams",[]]
];

if !(_OK) exitWith
{
	diag_log format ["DMS ERROR :: Called MISSION nedbandit1_mission.sqf with invalid parameters: %1",_this];
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	
								"easy",
								"moderate",
								"moderate",
								"moderate",
								"difficult",
								"difficult",
								"difficult",
								"hardcore",
								"hardcore"
							];
//choose difficulty and set value
_difficulty = selectRandom _PossibleDifficulty;

switch (_difficulty) do
{
	case "easy":
	{
_AICount = (4 + (round (random 4)));
_VehicleChance = 20;												//20% SpawnPersistentVehicle chance
_ned_VehicleItems = [["U_NikosAgedBody",1,0], ["U_NikosBody",1,1], ["H_Cap_press",1,0],["H_StrawHat_dark",1,0], ["Exile_Item_EMRE",1,1], ["Exile_Item_PlasticBottleCoffee",1,1], ["ItemGPS",1,0], ["hgun_Rook40_F",1,1], ["hgun_ACPC2_F",0,1], ["9Rnd_45ACP_Mag",1,1], ["16Rnd_9x21_Mag",1,1]];
_cash = (250 + round (random (500)));
	};
	case "moderate":
	{
_AICount = (7 + (round (random 2)));
_VehicleChance = 25;												//25% SpawnPersistentVehicle chance
_ned_VehicleItems = [["U_NikosAgedBody",1,1], ["U_NikosBody",1,2], ["H_Cap_press",1,1],["H_StrawHat_dark",1,1], ["Exile_Item_EMRE",1,2], ["Exile_Item_PlasticBottleCoffee",1,2], ["ItemGPS",1,1], ["hgun_Rook40_F",1,2], ["hgun_ACPC2_F",1,1], ["9Rnd_45ACP_Mag",2,2], ["16Rnd_9x21_Mag",2,2]];
_cash = (500 + round (random (750)));				
	};
	case "difficult":
	{
_AICount = (7 + (round (random 4)));
_VehicleChance = 33;												//33% SpawnPersistentVehicle chance
_ned_VehicleItems = [["U_NikosAgedBody",1,2], ["U_NikosBody",1,3], ["H_Cap_press",1,2],["H_StrawHat_dark",1,2], ["Exile_Item_EMRE",1,3], ["Exile_Item_PlasticBottleCoffee",1,3], ["ItemGPS",1,2], ["hgun_Rook40_F",1,3], ["hgun_ACPC2_F",1,2], ["9Rnd_45ACP_Mag",3,3], ["16Rnd_9x21_Mag",3,3]];
_cash = (750 + round (random (1000)));
	};
	//case "hardcore":
	default
	{
_AICount = (7 + (round (random 6)));
_VehicleChance = 50;												//50% SpawnPersistentVehicle chance
_ned_VehicleItems = [["U_NikosAgedBody",1,3], ["U_NikosBody",1,4], ["H_Cap_press",1,3],["H_StrawHat_dark",1,3], ["Exile_Item_EMRE",1,4], ["Exile_Item_PlasticBottleCoffee",1,4], ["ItemGPS",1,3], ["hgun_Rook40_F",1,4], ["hgun_ACPC2_F",2,2], ["9Rnd_45ACP_Mag",4,4], ["16Rnd_9x21_Mag",4,4]];
_cash = (1000 + round (random (1500)));
	};
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleColour		= 	[	
								"red",
								"black",
								"grey",
								"orange",
								"special"
							];
//choose colour and set value
_colour = selectRandom _PossibleColour;

switch (_colour) do
{
	case "red":
	{
	_vehicleP = "Exile_Car_SUV_Red";
	_missionName = "Code-Red Bandit Outlaw";
	};
	case "black":
	{
	_vehicleP = "Exile_Car_SUV_Black";
	_missionName = "Code-Black Bandit Outlaw";
	};
	case "grey":
	{
	_vehicleP = "Exile_Car_SUV_Grey";
	_missionName = "Code-Grey Bandit Outlaw";
	};
	case "orange":
	{							
	_vehicleP = "Exile_Car_SUV_Orange";
	_missionName = "Code-Orange Bandit Outlaw";
	};
	//case "special":
	default
	{							
	_vehicleP = "Exile_Car_SUV_Armed_Black";
	_missionName = "Code-Special Bandit Outlaw";
	};
};							

// is %chance greater than random number
if (_VehicleChance >= (random 100)) then {
												_pinCode = (1000 +(round (random 8999)));
												_vehicle = [_vehicleP,[(_pos select 0), (_pos select 1)],_pinCode] call DMS_fnc_SpawnPersistentVehicle;
												_msgWIN = ['#0080ff',format["Convicts have successfully eliminated the %1 bandit outlaw, entry code is %2 ...",_colour,_pinCode]];
												_Vwin = "Win";	//just for logging purposes
											} else
											{
												_vehicle = [_vehicleP,[(_pos select 0), (_pos select 1),0],[], 0, "CAN_COLLIDE"] call DMS_fnc_SpawnNonPersistentVehicle;
												_msgWIN = ['#0080ff',format["Convicts have successfully eliminated the %1 bandit outlaw",_colour]];
												_Vwin = "Lose";	//just for logging purposes
											};							

//export to logs for testing - comment next line out for no log
diag_log format ["nedbandit1 :: Called MISSION with these parameters: >>AI Group: %1 (plus leader) >>Cash: %2 >>Vwin: %3 >>Colour: %4 >>Difficulty: %5 >>Vehicle: %6",_AICount,_cash,_Vwin,_colour,_difficulty,_vehicleP];
											
// no crate so load vehicle with basic goodies
	clearMagazineCargoGlobal _vehicle;
	clearWeaponCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;							
	{
		_item = _x select 0;
		_amount = _x select 1;
		_randomAmount = _x select 2;
		_amount = _amount + (random _randomAmount);
		_itemType = _x call BIS_fnc_itemType;

		if((_itemType select 0) == "Weapon") then {_vehicle addWeaponCargoGlobal [_item, _amount];};
		if((_itemType select 0) == "Magazine") then {_vehicle addMagazineCargoGlobal [_item, _amount];};
		if((_itemType select 0) == "Item") then {_vehicle addItemCargoGlobal [_item, _amount];};
		if((_itemType select 0) == "Equipment") then {_vehicle addItemCargoGlobal [_item, _amount];};
		if((_itemType select 0) == "Backpack") then {_vehicle addBackpackCargoGlobal [_item, _amount];};
	}forEach _ned_VehicleItems;
// load tabs in
_vehicle setVariable ["ExileMoney", _cash,true]; 


// Create customised leader AI
_customGearSet2 = 	[
						"Exile_Weapon_M1014",												// String | EG: "LMG_Zafir_F"
						[],																	// Array of strings | EG: ["optic_dms","bipod_03_F_blk"]
						[["9Rnd_45ACP_Mag",1],["Exile_Magazine_8Rnd_74Pellets",3]],			// Array of arrays | EG: [["150Rnd_762x54_Box",2],["16Rnd_9x21_Mag",3],["Exile_Item_InstaDoc",3]]
						"hgun_ACPC2_F",														// String | EG: "hgun_Pistol_heavy_01_snds_F"
						["muzzle_snds_acp"],												// Array of strings | EG: ["optic_MRD","muzzle_snds_acp"]
						["ItemGPS"],														// Array of strings | EG: ["Rangefinder","ItemGPS","NVGoggles"]
						"",																	// String | EG: "launch_RPG32_F"
						"H_StrawHat",														// String | EG: "H_HelmetLeaderO_ocamo"
						"U_Competitor",														// String | EG: "U_O_GhillieSuit"
						"V_BandollierB_blk",												// String | EG: "V_PlateCarrierGL_blk"
						""																	// String | EG: "B_Carryall_oli"
					];
_group2 =
[
	_pos,					// Position of AI
	1,						// Just 1 leader
	_difficulty,			// chosen in difficulty
	"custom", 				// "custom"
	_side, 					// "bandit"
	_customGearSet2			// customise with gear above
] call DMS_fnc_SpawnAIGroup;


// Create customised AI group
_customGearSet = 	[
						"Exile_Weapon_AK47",												// String | EG: "LMG_Zafir_F"
						["optic_Holosight"],												// Array of strings | EG: ["optic_dms","bipod_03_F_blk"]
						[["Exile_Magazine_30Rnd_762x39_AK",3],["9Rnd_45ACP_Mag",3]],		// Array of arrays | EG: [["150Rnd_762x54_Box",2],["16Rnd_9x21_Mag",3],["Exile_Item_InstaDoc",3]]
						"hgun_ACPC2_F",														// String | EG: "hgun_Pistol_heavy_01_snds_F"
						["muzzle_snds_acp"],												// Array of strings | EG: ["optic_MRD","muzzle_snds_acp"]
						["ItemGPS"],														// Array of strings | EG: ["Rangefinder","ItemGPS","NVGoggles"]
						"",																	// String | EG: "launch_RPG32_F"
						"H_Cap_blk",														// String | EG: "H_HelmetLeaderO_ocamo"
						"U_Marshal",														// String | EG: "U_O_GhillieSuit"
						"V_BandollierB_blk",												// String | EG: "V_PlateCarrierGL_blk"
						""																	// String | EG: "B_Carryall_oli"
					];

_group =
[
	_pos,					// Position of AI
	_AICount,				// chosen in difficulty
	_difficulty,			// chosen in difficulty
	"custom", 				// "custom"
	_side, 					// "bandit"
	_customGearSet			// customise with gear above
] call DMS_fnc_SpawnAIGroup;


// Define mission-spawned AI Units
_missionAIUnits =
[
	_group2,		// AI leader
	_group			// AI group
];

// Define mission-spawned objects and loot values
_missionObjs =
[
	[],
	[_vehicle],	//prize vehicle
	[]
];

// define start messages with difficulty choice
_msgStart = ['#FFFF00',format["A %1 class bandit outlaw has escaped, go kill this %2 outlaw!",_colour,_difficulty]];

// Define Mission Win message - defined in persistent vehicle toss

// Define Mission Lose message
_msgLOSE = ['#FF0000',format["The %1 bandit outlaw has escaped",_colour]];

// Define mission name (for map marker and logging) - defined in colour choice


// Create Markers
_markers =
[
	_pos,
	_missionName,
	_difficulty
] call DMS_fnc_CreateMarker;

// Record time here (for logging purposes, otherwise you could just put "diag_tickTime" into the "DMS_AddMissionToMonitor" parameters directly)
_time = diag_tickTime;

// Parse and add mission info to missions monitor
_added =
[
	_pos,
	[
		[
			"kill",
			[_group,_group2]
		],
		[
			"playerNear",
			[_pos,DMS_playerNearRadius]
		]
	],
	[
		_time,
		(DMS_MissionTimeOut select 0) + random((DMS_MissionTimeOut select 1) - (DMS_MissionTimeOut select 0))
	],
	_missionAIUnits,
	_missionObjs,
	[_missionName,_msgWIN,_msgLOSE],
	_markers,
	_side,
	_difficulty,
	[]
] call DMS_fnc_AddMissionToMonitor;

// Check to see if it was added correctly, otherwise delete the stuff
if !(_added) exitWith
{
	diag_log format ["DMS ERROR :: Attempt to set up mission %1 with invalid parameters for DMS_AddMissionToMonitor! Deleting mission objects and resetting DMS_MissionCount.",_missionName];

	// Delete AI units and the crate. I could do it in one line but I just made a little function that should work for every mission (provided you defined everything correctly)
	_cleanup = [];
	{
		_cleanup pushBack _x;
	} forEach _missionAIUnits;

	_cleanup pushBack ((_missionObjs select 0)+(_missionObjs select 1));

	{
		_cleanup pushBack (_x select 0);
	} foreach (_missionObjs select 2);

	_cleanup call DMS_fnc_CleanUp;

	// Delete the markers directly
	{deleteMarker _x;} forEach _markers;

	// Reset the mission count
	DMS_MissionCount = DMS_MissionCount - 1;
};

// Notify players
[_missionName,_msgStart] call DMS_fnc_BroadcastMissionStatus;

if (DMS_DEBUG) then
{
	(format ["MISSION: (%1) :: Mission #%2 started at %3 with %4 AI units and %5 difficulty at time %6",_missionName,_num,_pos,_AICount,_difficulty,_time]) call DMS_fnc_DebugLog;
};