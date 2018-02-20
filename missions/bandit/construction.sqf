/*
	Construction Mission with new difficulty selection system
	Created by Defent and eraser1
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_group", "_pos", "_side", "_OK", "_difficulty", "_AICount", "_type", "_launcher", "_crate", "_wreck1", "_wreck2", "_wreck3", "_vehClass", "_vehicle", "_crate_loot_values", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_crate_weapons", "_crate_items", "_crate_item_list", "_crate_backpacks", "_PossibleDifficulty"];

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
		[25,DMS_WaterNearBlacklist,DMS_MinSurfaceNormal,DMS_SpawnZoneNearBlacklist,DMS_TraderZoneNearBlacklist,DMS_MissionNearBlacklist,DMS_PlayerNearBlacklist,DMS_TerritoryNearBlacklist,DMS_ThrottleBlacklists],
		[
			[]
		],
		_this
	];
};

// Check calling parameters for manually defined mission position.
// You can define "_extraParams" to specify the vehicle classname to spawn, either as _classname or [_classname]
_OK = (_this call DMS_fnc_MissionParams) params
[
	["_pos",[],[[]],[3]],
	["_extraParams",[]]
];

if !(_OK) exitWith
{
	diag_log format ["DMS ERROR :: Called MISSION construction.sqf with invalid parameters: %1",_this];
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[
								"easy",
								"moderate",
								"moderate",
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
_AICount = (5 + (round (random 2)));
_crate_weapons 		= (1 + (round (random 1)));
_crate_items 		= (8 + (round (random 4)));
_crate_backpacks 	= (1 + (round (random 1)));
DMS_ai_use_launchers = false;										//overwrites main DMS config setting
	};
	case "moderate":
	{
_AICount = (5 + (round (random 4)));
_crate_weapons 		= (1 + (round (random 2)));
_crate_items 		= (12 + (round (random 4)));
_crate_backpacks 	= (2 + (round (random 1)));
	};
	case "difficult":
	{
_AICount = (5 + (round (random 4)));
_crate_weapons 		= (2 + (round (random 2)));
_crate_items 		= (15 + (round (random 6)));
_crate_backpacks 	= (3 + (round (random 1)));
	};
	//case "hardcore":
	default
	{
_AICount = (5 + (round (random 4)));
_crate_weapons 		= (3 + (round (random 3)));
_crate_items 		= (20 + (round (random 6)));
_crate_backpacks 	= (4 + (round (random 1)));
	};
};

// used for all
_crate_item_list	= ["DMS_BoxBuildingSupplies"];

_group =
[
	_pos,					// Position of AI
	_AICount,				// Number of AI
	_difficulty,			// "random","hardcore","difficult","moderate", or "easy"
	"random", 				// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
	_side 					// "bandit","hero", etc.
] call DMS_fnc_SpawnAIGroup;

// Create Crate
_crate = ["Box_NATO_Wps_F",[(_pos select 0)+2,(_pos select 1)-1,0]] call DMS_fnc_SpawnCrate;

_wreck1 = createVehicle ["Land_CinderBlocks_F",[(_pos select 0) - 10, (_pos select 1),-0.1],[], 0, "CAN_COLLIDE"];
_wreck2 = createVehicle ["Land_Bricks_V1_F",[(_pos select 0) - 5, (_pos select 1),-3.3],[], 0, "CAN_COLLIDE"];
_wreck3 = createVehicle ["Land_Bricks_V1_F",[(_pos select 0) - 13, (_pos select 1),-1],[], 0, "CAN_COLLIDE"];

// Check to see if a special vehicle class is defined in "_extraParams", and make sure it's valid, otherwise use the default (Offroad Armed)
_vehClass =
	if (_extraParams isEqualTo []) then
	{
		"Exile_Car_Zamak"
	}
	else
	{
		if ((typeName _extraParams)=="STRING") then
		{
			_extraParams
		}
		else
		{
			if (((typeName _extraParams)=="ARRAY") && {(typeName (_extraParams select 0))=="STRING"}) then
			{
				_extraParams select 0
			}
			else
			{
				"Exile_Car_Zamak"
			};
		};
	};

_vehicle = [_vehClass,_pos] call DMS_fnc_SpawnNonPersistentVehicle;

// Set crate loot values
_crate_loot_values =
[
	_crate_weapons,									// Weapons
	[_crate_items,DMS_BoxBuildingSupplies],			// Items
	_crate_backpacks 								// Backpacks
];

// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

// Define mission-spawned objects and loot values
_missionObjs =
[
	[_wreck1,_wreck2,_wreck3],			// No spawned buildings
	[_vehicle],
	[[_crate,_crate_loot_values]]
];

// define start messages with difficulty choice
_msgStart = ['#FFFF00',format["A group of %1 mercenaries have set up a construction site. Clear them out!",_difficulty]];

// Define Mission Win message
_msgWIN = ['#0080ff',"Convicts have successfully demolished the construction site!"];

// Define Mission Lose message
_msgLOSE = ['#FF0000',"The mercenaries have dismantled their construction site and escaped!"];

// Define mission name (for map marker and logging)
_missionName = "Construction Site";

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