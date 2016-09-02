/*
	Thieves Mission Z-Theme Variation with new difficulty selection system
	Mission gives % chance of persistent vehicle
	Created by Defent and eraser1
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_side", "_OK", "_group", "_pos", "_difficulty", "_AICount", "_extraParams", "_type", "_launcher", "_class", "_pinCode", "_vehicle", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_PossibleDifficulty", "_VehicleChance", "_customGearSet"];

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
		[15,DMS_WaterNearBlacklist,DMS_MinSurfaceNormal,DMS_SpawnZoneNearBlacklist,DMS_TraderZoneNearBlacklist,DMS_MissionNearBlacklist,DMS_PlayerNearBlacklist,DMS_TerritoryNearBlacklist,DMS_ThrottleBlacklists],
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
	diag_log format ["DMS ERROR :: Called MISSION thievesZ.sqf with invalid parameters: %1",_this];
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	
								"easy",
								"easy",
								"easy",
								"easy",
								"easy",
								"easy",
								"moderate",
								"moderate",
								"moderate",
								"moderate",
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
	};
	case "moderate":
	{
_AICount = (4 + (round (random 2)));
_VehicleChance = 20;												//20% SpawnPersistentVehicle chance
	};
	case "difficult":
	{
_AICount = (4 + (round (random 3)));
_VehicleChance = 50;												//50% SpawnPersistentVehicle chance
	};
	//case "hardcore":
	default
	{
_AICount = (4 + (round (random 4)));
_VehicleChance = 90;												//90% SpawnPersistentVehicle chance
	};
};

// Create customised AI group
_customGearSet = 	[
						"Exile_Weapon_AK47",												// String | EG: "LMG_Zafir_F"
						["optic_Holosight"],												// Array of strings | EG: ["optic_dms","bipod_03_F_blk"]
						[["Exile_Magazine_30Rnd_762x39_AK",3],["9Rnd_45ACP_Mag",3]],		// Array of arrays | EG: [["150Rnd_762x54_Box",2],["16Rnd_9x21_Mag",3],["Exile_Item_InstaDoc",3]]
						"hgun_ACPC2_F",														// This is just a shotgun // String | EG: "hgun_Pistol_heavy_01_snds_F"
						["muzzle_snds_acp"],												// Array of strings | EG: ["optic_MRD","muzzle_snds_acp"]
						["ItemGPS"],														// Array of strings | EG: ["Rangefinder","ItemGPS","NVGoggles"]
						"",																	// Not adding rocket launcher // String | EG: "launch_RPG32_F"
						"Exile_Headgear_GasMask",											// Uniform to be dressed in
						"C_scientist_F",													// SAdded gasmask for effect
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

_class =
	if (_extraParams isEqualTo []) then
	{
		DMS_CarThievesVehicles call BIS_fnc_SelectRandom
	}
	else
	{
		if (_extraParams isEqualType "") then
		{
			_extraParams
		}
		else
		{
			if ((_extraParams isEqualType []) && {(_extraParams select 0) isEqualType ""}) then
			{
				_extraParams select 0
			}
			else
			{
				DMS_CarThievesVehicles call BIS_fnc_SelectRandom
			};
		};
	};

// is %chance greater than random number
if (_VehicleChance >= (random 100)) then {
												_pinCode = (1000 +(round (random 8999)));
												_vehicle = [_class,_pos,_pinCode] call DMS_fnc_SpawnPersistentVehicle;
												_msgWIN = ['#0080ff',format ["Convicts have eliminated the thieves! No cure but the vehicle code was %1...",_pinCode]];
												
											} else
											{
												_vehicle = [_class,_pos] call DMS_fnc_SpawnNonPersistentVehicle;
												_msgWIN = ['#0080ff',"Convicts have eliminated the thieves! No cure but the search continues"];
											};
											
// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

// Define mission-spawned objects
_missionObjs =
[
	[],			// No spawned buildings
	[_vehicle],
	[]
];

// Define Mission Start message
_msgStart = ['#FFFF00',format ["A band of thieves have stolen a %1 from a research scientist. Eliminate them and see if there is a cure in it!",getText (configFile >> "CfgVehicles" >> _class >> "displayName")]];

// Define Mission Win message in persistent choice

// Define Mission Lose message
_msgLOSE = ['#FF0000',"The thieves got away and we will never know if the cure was inside!"];

// Define mission name (for map markers, mission messages, and logging)
_missionName = "Car Cure";

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
			_group,
			true
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