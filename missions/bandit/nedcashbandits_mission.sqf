/*
	ned Cash Bandits Mission with difficulty selection system
	Changeable % chance for permenant vehicle
	rework of bandits mission with only cash reward originally	created by Defent and eraser1
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_side", "_pos", "_OK", "_difficulty", "_extraParams", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_crate1", "_vehicle", "_pinCode", "_class", "_veh", "_crate_loot_values", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_crate_weapons", "_crate_items", "_crate_backpacks", "_PossibleDifficulty", "_cash", "_VehicleChance", "_PossibleVehicleClass", "_VehicleClass"];

// For logging purposes
_num = DMS_MissionCount;

// Set mission side (only "bandit" is supported for now)
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
	["_pos","_pos ERROR",[[]],[3]],
	["_extraParams",[]]
];

if !(_OK) exitWith
{
	diag_log format ["DMS ERROR :: Called MISSION bandits.sqf with invalid parameters: %1",_this];
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	
								"easy",
								"easy",
								"easy",
								"easy",
								"moderate",
								"moderate",
								//"moderate",
								//"difficult",
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
_cash = (250 + round (random (500)));							//this gives 250 to 750 cash
_VehicleChance = 20;											//20% SpawnPersistentVehicle chance
_PossibleVehicleClass = [		"Exile_Car_Offroad_DarkRed",
								"Exile_Car_Offroad_BlueCustom",
								"Exile_Car_Lada_Green",
								"Exile_Car_Lada_Taxi",
								"Exile_Car_Lada_Red",
								"Exile_Car_Lada_White",
								"Exile_Car_Lada_Hipster",
								"Exile_Car_Volha_Blue",
								"Exile_Car_Volha_White",
								"Exile_Car_Volha_Black",
								"Exile_Car_Offroad_Guerilla01",
								"Exile_Car_Offroad_Guerilla02",
								"Exile_Car_Offroad_Guerilla03"
						];										//possible vehicle list
_crate_weapons 		= 0;										//cash mission but you could add weapons e.g. = (2 + (round (random 3)));
_crate_items 		= 0;										//cash mission but you could add items e.g. = (2 + (round (random 4)));
_crate_backpacks 	= 0;										//cash mission but you could add backpacks e.g. = (1 + (round (random 1)));
	};
	case "moderate":
	{
_AICount = (4 + (round (random 2)));
_cash = (500 + round (random (750)));							//this gives 500 to 1250 cash	
_VehicleChance = 25;											//25% SpawnPersistentVehicle chance
_PossibleVehicleClass = [		"Exile_Car_Offroad_DarkRed",
								"Exile_Car_Offroad_BlueCustom",
								"Exile_Car_Offroad_Guerilla01",
								"Exile_Car_Offroad_Guerilla02",
								"Exile_Car_Offroad_Guerilla03",
								"Exile_Car_Offroad_Guerilla04",
								"Exile_Car_Offroad_Guerilla05",
								"Exile_Car_Offroad_Guerilla06",
								"Exile_Car_Offroad_Guerilla07",
								"Exile_Car_Offroad_Guerilla08",
								"Exile_Car_Offroad_Guerilla09",
								"Exile_Car_Offroad_Guerilla10",
								"Exile_Car_Offroad_Guerilla11",
								"Exile_Car_Offroad_Guerilla12"
						];										//possible vehicle list
_crate_weapons 		= 0;										//cash mission but you could add weapons e.g. = (2 + (round (random 3)));
_crate_items 		= 0;										//cash mission but you could add items e.g. = (2 + (round (random 4)));
_crate_backpacks 	= 0;										//cash mission but you could add backpacks e.g. = (1 + (round (random 1)));		
	};
	case "difficult":
	{
_AICount = (4 + (round (random 3)));
_cash = (750 + round (random (1000)));							//this gives 750 to 1750 cash
_VehicleChance = 33;											//33% SpawnPersistentVehicle chance
_PossibleVehicleClass = [		"Exile_Car_Offroad_Guerilla01",
								"Exile_Car_Offroad_Guerilla02",
								"Exile_Car_Offroad_Guerilla03",
								"Exile_Car_Offroad_Guerilla04",
								"Exile_Car_Offroad_Guerilla05",
								"Exile_Car_Offroad_Guerilla06",
								"Exile_Car_Offroad_Guerilla07",
								"Exile_Car_Offroad_Guerilla08",
								"Exile_Car_Offroad_Guerilla09",
								"Exile_Car_Offroad_Guerilla10",
								"Exile_Car_Offroad_Guerilla11",
								"Exile_Car_Offroad_Guerilla12",
								"Exile_Car_Offroad_Armed_Guerilla01",
								"Exile_Car_Offroad_Armed_Guerilla02",
								"Exile_Car_Offroad_Armed_Guerilla03",
								"Exile_Car_Offroad_Armed_Guerilla04",
								"Exile_Car_Offroad_Armed_Guerilla05",
								"Exile_Car_Offroad_Armed_Guerilla06"
						];										//possible vehicle list
_crate_weapons 		= 0;										//cash mission but you could add weapons e.g. = (2 + (round (random 3)));
_crate_items 		= 0;										//cash mission but you could add items e.g. = (2 + (round (random 4)));
_crate_backpacks 	= 0;										//cash mission but you could add backpacks e.g. = (1 + (round (random 1)));
	};
	//case "hardcore":
	default
	{
_AICount = (4 + (round (random 4)));
_cash = (1000 + round (random (1500)));							//this gives 1000 to 2500 cash
_VehicleChance = 50;											//50% SpawnPersistentVehicle chance
_PossibleVehicleClass = [		"Exile_Car_Offroad_Guerilla01",
								"Exile_Car_Offroad_Guerilla02",
								"Exile_Car_Offroad_Guerilla03",
								"Exile_Car_Offroad_Guerilla04",
								"Exile_Car_Offroad_Guerilla05",
								"Exile_Car_Offroad_Guerilla06",
								"Exile_Car_Offroad_Armed_Guerilla01",
								"Exile_Car_Offroad_Armed_Guerilla02",
								"Exile_Car_Offroad_Armed_Guerilla03",
								"Exile_Car_Offroad_Armed_Guerilla04",
								"Exile_Car_Offroad_Armed_Guerilla05",
								"Exile_Car_Offroad_Armed_Guerilla06",
								"Exile_Car_Offroad_Armed_Guerilla07",
								"Exile_Car_Offroad_Armed_Guerilla08",
								"Exile_Car_Offroad_Armed_Guerilla09",
								"Exile_Car_Offroad_Armed_Guerilla10",
								"Exile_Car_Offroad_Armed_Guerilla11",
								"Exile_Car_Offroad_Armed_Guerilla12"
						];										//possible vehicle list
_crate_weapons 		= 0;										//cash mission but you could add weapons e.g. = (2 + (round (random 3)));
_crate_items 		= 0;										//cash mission but you could add items e.g. = (2 + (round (random 4)));
_crate_backpacks 	= 0;										//cash mission but you could add backpacks e.g. = (1 + (round (random 1)));
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

// Create Crate
_crate = ["Box_NATO_Wps_F",_pos] call DMS_fnc_SpawnCrate;


// select randomly from _PossibleVehicleClass in settings
_VehicleClass  = selectRandom _PossibleVehicleClass;
				
// is %chance greater than random number
if (_VehicleChance >= (random 100)) then {
												_pinCode = (1000 +(round (random 8999)));
												_vehicle = [_VehicleClass,[(_pos select 0) -10, (_pos select 1) +10],_pinCode] call DMS_fnc_SpawnPersistentVehicle;
												_msgWIN = ['#0080ff',format["Convicts have successfully taken care of the bandits and taken their cash and vehicle, entry code is %1 ...",_pinCode]];
											} else
											{
												_vehicle = [_VehicleClass,[(_pos select 0) -10, (_pos select 1) +10]] call DMS_fnc_SpawnNonPersistentVehicle;
												_msgWIN = ['#0080ff',"Convicts have successfully taken care of the bandit group and taken their cash!"];
											};
	
// setup crate iteself with items from choice
_crate_loot_values =
						[
							_crate_weapons,			// Weapons
							_crate_items,			// Items + selection list
							_crate_backpacks 		// Backpacks
						];

// add cash to crate
_crate setVariable ["ExileMoney", _cash,true];

// Define mission-spawned AI Units
_missionAIUnits =
					[
						_group 		// We only spawned the single group for this mission
					];

// Define mission-spawned objects and loot values
_missionObjs =
				[
					[],			// No spawned buildings
					[_vehicle],
					[[_crate,_crate_loot_values]]
				];

// Define Mission Start message
_msgStart = ['#FFFF00',format["A heavily armed bandit group has been spotted, take the %1 bandits out and claim their vehicle and the cash they stole!",_difficulty]];

// Define Mission Win message in vehicle choice

// Define Mission Lose message
_msgLOSE = ['#FF0000',"The bandits have driven off with the cash, no loot today!"];

// Define mission name (for map markers, mission messages, and logging)
_missionName = "Cash Bandits";

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