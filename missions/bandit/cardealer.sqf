/*
	Car Dealer Mission with new difficulty selection system
	Random SUV chosen for prizes, Mission gives % chance of 2nd vehicle
	Created by Defent and eraser1
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_side", "_pos", "_OK", "_difficulty", "_extraParams", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_wreck", "_crate", "_crate1", "_vehicle", "_PossibleVehicleClass", "_pinCode", "_class", "_veh", "_crate_loot_values", "_crate_loot_values1", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_crate_weapons", "_crate_weapon_list", "_crate_items", "_crate_item_list", "_crate_backpacks", "_PossibleDifficulty", "_VehicleChance"];

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
// You can use _extraParams to define which vehicles to spawn. _vehClass1, [_vehClass1], or [_vehClass1,_vehClass2]
_OK = (_this call DMS_fnc_MissionParams) params
[
	["_pos",[],[[]],[3]],
	["_extraParams",[]]
];

if !(_OK) exitWith
{
	diag_log format ["DMS ERROR :: Called MISSION cardealer.sqf with invalid parameters: %1",_this];
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	
								"easy",
								"easy",
								"moderate",
								"moderate",
								"moderate",
								"difficult",
								"difficult",
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
_VehicleChance = 40;												//40% Spawn 2 Vehicles chance
_crate_weapons 		= (2 + (round (random 3)));
_crate_items 		= (2 + (round (random 4)));
_crate_backpacks 	= (1 + (round (random 1)));
	};
	case "moderate":
	{
_AICount = (4 + (round (random 2)));
_VehicleChance = 60;												//60% Spawn 2 Vehicles chance
_crate_weapons 		= (3 + (round (random 5)));
_crate_items 		= (3 + (round (random 6)));
_crate_backpacks 	= (2 + (round (random 1)));
	};
	case "difficult":
	{
_AICount = (4 + (round (random 3)));
_VehicleChance = 75;												//75% Spawn 2 Vehicles chance
_crate_weapons 		= (4 + (round (random 7)));
_crate_items 		= (4 + (round (random 8)));
_crate_backpacks 	= (3 + (round (random 1)));
	};
	//case "hardcore":
	default
	{
_AICount = (4 + (round (random 4)));
_VehicleChance = 90;												//90% Spawn 2 Vehicles chance
_crate_weapons 		= (5 + (round (random 9)));
_crate_items 		= (5 + (round (random 10)));
_crate_backpacks 	= (4 + (round (random 1)));
	};
};
								
_group =
[
	_pos,					// Position of AI
	_AICount,				// Number of AI
	_difficulty,			// "random","hardcore","difficult","moderate", or "easy"
	"random", 				// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
	_side 					// "bandit","hero", etc.
] call DMS_fnc_SpawnAIGroup;

// Create Crates
_crate1 = ["Box_NATO_Wps_F",_pos] call DMS_fnc_SpawnCrate;

_rndDir = random 180;

_wreck = createVehicle ["Land_FuelStation_Build_F",[_pos,10+(random 5),_rndDir+90] call DMS_fnc_SelectOffsetPos,[], 0, "CAN_COLLIDE"];

_PossibleVehicleClass 		= [	
								"Exile_Car_SUV_Red",
								"Exile_Car_SUV_Black",
								"Exile_Car_SUV_Grey",
								"Exile_Car_SUV_Orange",
								"Exile_Car_SUV_Red",
								"Exile_Car_SUV_Black",
								"Exile_Car_SUV_Grey",
								"Exile_Car_SUV_Orange",
								"Exile_Car_SUV_Red",
								"Exile_Car_SUV_Black",
								"Exile_Car_SUV_Grey",
								"Exile_Car_SUV_Orange",
								"Exile_Car_SUVXL_Black"
							];
//choose the vehicle
_vehClass1 = selectRandom _PossibleVehicleClass;
_vehClass2 = selectRandom _PossibleVehicleClass;

// vehicle 1 is always spawned
_vehicle1 = [_vehClass1, [_pos,5+(random 3),_rndDir] call DMS_fnc_SelectOffsetPos] call DMS_fnc_SpawnNonPersistentVehicle;

// Set crate loot values
_crate_loot_values1 =
[
	_crate_weapons,			// Weapons
	_crate_items,			// Items
	_crate_backpacks 		// Backpacks
];

// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

// is %chance greater than random number add 2nd vehicle and adjust clean up script to include
if (_VehicleChance >= (random 100)) then {
_vehicle2 = [_vehClass2, [_pos,5+(random 3),_rndDir+180] call DMS_fnc_SelectOffsetPos] call DMS_fnc_SpawnNonPersistentVehicle;
_missionObjs =
[
	[_wreck],
	[_vehicle1,_vehicle2],
	[[_crate1,_crate_loot_values1]]
];
									} else
									{
_missionObjs =
[
	[_wreck],
	[_vehicle1],
	[[_crate1,_crate_loot_values1]]
];			
									};																	
								
// define start messages with difficulty choice
_msgStart = ['#FFFF00',format["A local car dealership is being robbed by %1 bandits. Stop them!",_difficulty]];

// Define Mission Win message
_msgWIN = ['#0080ff',"Convicts have secured the local dealership and eliminated the bandits!"];

// Define Mission Lose message
_msgLOSE = ['#FF0000',"The bandits have escaped with the cars and left nothing but a trail of smoke behind!"];

// Define mission name (for map marker and logging)
_missionName = "Car Dealer Robbery";

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