/*
	Zombie Test mission, very simple logic
	Originally created by Defent and eraser1
	reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_side", "_OK", "_group", "_pos", "_difficulty", "_AICount", "_type", "_launcher", "_crate", "_crate_loot_values", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_Zombies", "_Zside"];

// For logging purposes
_num = DMS_MissionCount;

// Set mission side - not used for zombies but i think the mission monitor only works with this
_side = bandit;

//use this for zombies side
_Zside = createcenter east;

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
	diag_log format ["DMS ERROR :: Called MISSION nedztest.sqf with invalid parameters: %1",_this];
};

// Set general mission difficulty
_difficulty = "easy";

_group = [
			_pos, 
			_Zside, 
			[
				"RyanZombieC_man_1", 
				"RyanZombieC_man_polo_1_F", 
				"RyanZombieC_man_polo_2_F", 
				"RyanZombieC_man_polo_4_F", 
				"RyanZombieC_man_polo_5_F", 
				"RyanZombieC_man_polo_6_F", 
				"RyanZombieC_man_p_fugitive_F", 
				"RyanZombieC_man_w_worker_F", 
				"RyanZombieC_scientist_F", 
				"RyanZombieC_man_hunter_1_F", 
				"RyanZombieC_man_pilot_F", 
				"RyanZombieC_journalist_F", 
				"RyanZombieC_Orestes", 
				"RyanZombieC_Nikos"
			], 
			[], 
			[], 
			[0.3, 0.6]
		] call BIS_fnc_spawnGroup;

//Hunt Player Logic
_Zombies= leader _group;
_Zombies move (getPosATL player);
_group setCombatMode "RED";
_group setBehaviour "Aware";
_group allowFleeing 0;

// Create Crate
_crate = ["Box_NATO_Wps_F",_pos] call DMS_fnc_SpawnCrate;

// Set crate loot values
_crate_loot_values =
[
	8,		// Weapons
	5,		// Items
	2 		// Backpacks
];

// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

// Define mission-spawned objects and loot values
_missionObjs =
[
	[],
	[],
	[[_crate,_crate_loot_values]]
];

// Define Mission Start message
_msgStart = ['#FFFF00',"A battalion of zombies have gotten lost in convict land! Eliminate them!"];

// Define Mission Win message
_msgWIN = ['#0080ff',"Convicts have successfully eliminated the lost zombie battalion!"];

// Define Mission Lose message
_msgLOSE = ['#FF0000',"Zombies escaped with their Lost Battalion!"];

// Define mission name (for map marker and logging)
_missionName = "Lost Zombie Battalion";

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