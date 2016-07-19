/*
	Medical Mission with new difficulty selection system
	Hardcore has 50% for persistent vehicle
	Created by Defent and eraser1
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_side", "_OK", "_group", "_pos", "_difficulty", "_AICount", "_type", "_launcher", "_crate", "_building", "_vehicle", "_pinCode", "_crate_loot_values", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_crate_weapons", "_crate_weapon_list", "_crate_items", "_crate_item_list", "_crate_backpacks", "_PossibleDifficulty", "_VehicleChance"];

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
// This mission doesn't use "_extraParams" in any way currently.
_OK = (_this call DMS_fnc_MissionParams) params
[
	["_pos",[],[[]],[3]],
	["_extraParams",[]]
];

if !(_OK) exitWith
{
	diag_log format ["DMS ERROR :: Called MISSION medical.sqf with invalid parameters: %1",_this];
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	
								"easy",
								"easy",
								"easy",
								"easy",
								"moderate",
								"moderate",
								"difficult",
								"hardcore"
							];
//choose difficulty and set value
_difficulty = selectRandom _PossibleDifficulty;

switch (_difficulty) do
{
	case "easy":
	{
_AICount = (3 + (round (random 2)));
_VehicleChance = 10;												//10% SpawnPersistentVehicle chance
_crate_weapons 		= (2 + (round (random 3)));
_crate_items 		= (2 + (round (random 4)));
_crate_backpacks 	= (1 + (round (random 1)));
	};
	case "moderate":
	{
_AICount = (4 + (round (random 2)));
_VehicleChance = 20;												//20% SpawnPersistentVehicle chance
_crate_weapons 		= (4 + (round (random 5)));
_crate_items 		= (4 + (round (random 6)));
_crate_backpacks 	= (2 + (round (random 1)));				
	};
	case "difficult":
	{
_AICount = (5 + (round (random 3)));
_VehicleChance = 30;												//30% SpawnPersistentVehicle chance
_crate_weapons 		= (6 + (round (random 7)));
_crate_items 		= (6 + (round (random 8)));
_crate_backpacks 	= (3 + (round (random 1)));
	};
	//case "hardcore":
	default
	{
_AICount = (6 + (round (random 4)));
_VehicleChance = 90;												//90% SpawnPersistentVehicle chance
_crate_weapons 		= (8 + (round (random 9)));
_crate_items 		= (8 + (round (random 10)));
_crate_backpacks 	= (4 + (round (random 1)));
	};
};

//use by all
_crate_item_list	= ["Exile_Item_InstaDoc","Exile_Item_PlasticBottleFreshWater","Exile_Item_Bandage","Exile_Item_PlasticBottleFreshWater","Exile_Item_Vishpirin","Exile_Item_PlasticBottleFreshWater","Exile_Item_Bandage","Exile_Item_Vishpirin","Exile_Item_Bandage","Exile_Item_Vishpirin","Exile_Item_Bandage","Exile_Item_Vishpirin","Exile_Item_InstaDoc","Exile_Item_Bandage","Exile_Item_Vishpirin","Exile_Item_Bandage","Exile_Item_Vishpirin","Exile_Item_Bandage","Exile_Item_Vishpirin"];
							
								
_group =
[
	_pos,					// Position of AI
	_AICount,				// Number of AI
	_difficulty,			// "random","hardcore","difficult","moderate", or "easy"
	"random", 				// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
	_side 					// "bandit","hero", etc.
] call DMS_fnc_SpawnAIGroup;

// Create Crate
_crate = ["Box_NATO_Wps_F",_pos] call DMS_fnc_SpawnCrate;

_building = createVehicle ["Land_Medevac_HQ_V1_F",[(_pos select 0) - 30, (_pos select 1),-10],[], 0, "CAN_COLLIDE"];

// is %chance greater than random number
if (_VehicleChance >= (random 100)) then {
											_pinCode = (1000 +(round (random 8999)));
											_vehicle = ["I_Truck_02_medical_F",_pos,_pinCode] call DMS_fnc_SpawnPersistentVehicle;
											_msgWIN = ['#0080ff',format ["Convicts have claimed the medical supplies for their own, vehicle entry code %1...",_pinCode]];
											} else
											{
											_vehicle = ["I_Truck_02_medical_F",_pos] call DMS_fnc_SpawnNonPersistentVehicle;
											_msgWIN = ['#0080ff',"Convicts have claimed the medical supplies for their own!"];
										};

// Set crate loot values
_crate_loot_values =
[
	_crate_weapons,								// Weapons
	[_crate_items,_crate_item_list],			// Items + selection list
	_crate_backpacks 							// Backpacks
];

// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

// Define mission-spawned objects and loot values
_missionObjs =
[
	[_building],			// Medevac
	[_vehicle],
	[[_crate,_crate_loot_values]]
];

// define start messages with difficulty choice
_msgStart = ['#FFFF00',format["A group of deranged %1 doctors have set up a field hospital. Seize it for your own!",_difficulty]];

// Define Mission Win message defined in persistent choice

// Define Mission Lose message
_msgLOSE = ['#FF0000',"Hawkeye has ran off with the medical supplies! Everything is gone!"];

// Define mission name (for map marker and logging)
_missionName = "Deranged Doctors";

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
			_group
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