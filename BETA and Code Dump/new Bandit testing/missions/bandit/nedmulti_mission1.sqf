/*
	Multi Mission #1 with new difficulty selection system and random message system
	Mission gives % chance of random class persistent vehicle
	Items and cash are loaded into vehicle so no crate
	based on work by Defent and eraser1
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_side", "_pos", "_OK", "_difficulty", "_extraParams", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_crate", "_vehicle", "_pinCode", "_class", "_veh", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_PossibleDifficulty", "_PossibleVehicleClass", "_VehicleClass", "_VehicleChance", "_Enemies", "_PossibleEnemies", "_Vehicletype", "_PossibleVehicletype", "_Dosomething", "_PossibleDosomething", "_Possiblevehiclecar", "_Possiblevehiclelandrover", "_Possiblevehiclevan", "_Possiblevehicletruck", "_Possiblevehicleoffroad", "_cash", "_ned_VehicleItems"];

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
		[10,DMS_WaterNearBlacklist,DMS_MinSurfaceNormal,DMS_SpawnZoneNearBlacklist,DMS_TraderZoneNearBlacklist,DMS_MissionNearBlacklist,DMS_PlayerNearBlacklist,DMS_TerritoryNearBlacklist,DMS_ThrottleBlacklists],
		[
			[]
		],
		_this
	];
};

// Check calling parameters for manually defined mission position.
// You can define "_extraParams" to specify the vehicle classname to spawn, either as _vehClass or [_vehClass]
_OK = (_this call DMS_fnc_MissionParams) params
[
	["_pos",[],[[]],[3],[],[],[]],
	["_extraParams",[]]
];

if !(_OK) exitWith
{
	diag_log format ["DMS ERROR :: Called MISSION nedmulti_mission1.sqf with invalid parameters: %1",_this];
};

// Set up some randomising of mission and messages, not used for anything else
// This is for mission message on who is attacking
_PossibleEnemies		= 	[
								"Bandits", 
								"Terrorists", 
								"Thieves", 
								"Admins"
							];
//choose enemy name and set value
_Enemies = selectRandom _PossibleEnemies;

// This is for mission message on attack type, not used for anything else
_PossibleDosomething	=	[
								"steal it", 
								"kill them", 
								"kick their asses",
								"show them who's boss"
							];
//choose attack type and set value
_Dosomething = selectRandom _PossibleDosomething;

// This choses which type of vehicle is in the mission, affects which vehicle list is used
_PossibleVehicletype	=	[
								"Car", 
								"LandRover", 
								"Van", 
								"Truck", 
								"Off-Road"
							];
//choose vehicle type and set value
_Vehicletype = selectRandom _PossibleVehicletype;

// Set up each possible vehicle type potential vehicle lists
_Possiblevehiclecar			= 	[
									"Exile_Car_Hatchback_Green",
									"Exile_Car_Hatchback_BlueCustom",
									"Exile_Car_Hatchback_BeigeCustom",
									"Exile_Car_Hatchback_Yellow",
									"Exile_Car_Hatchback_Grey",
									"Exile_Car_Hatchback_Black",
									"Exile_Car_Hatchback_Dark",
									"Exile_Car_Golf_Red",
									"Exile_Car_Golf_Black",
									"Exile_Car_Lada_Taxi",
									"Exile_Car_Lada_Hipster",
									"Exile_Car_Volha_Black"
								];
_Possiblevehiclelandrover	=	[
									"Exile_Car_LandRover_Red",
									"Exile_Car_LandRover_Urban",
									"Exile_Car_LandRover_Green",
									"Exile_Car_LandRover_Sand",
									"Exile_Car_LandRover_Desert",
									"Exile_Car_LandRover_Ambulance_Green",
									"Exile_Car_LandRover_Ambulance_Desert",
									"Exile_Car_LandRover_Ambulance_Sand"
								];
_Possiblevehiclevan			=	[
									"Exile_Car_Van_Black",
									"Exile_Car_Van_White",
									"Exile_Car_Van_Red",
									"Exile_Car_Van_Guerilla01",
									"Exile_Car_Van_Guerilla02",
									"Exile_Car_Van_Guerilla03",
									"Exile_Car_Van_Box_Black",
									"Exile_Car_Van_Box_White",
									"Exile_Car_Van_Box_Red",
									"Exile_Car_Van_Box_Guerilla01",
									"Exile_Car_Van_Box_Guerilla02",
									"Exile_Car_Van_Box_Guerilla03"						
								];
_Possiblevehicletruck		=	[
									"Exile_Car_Ural_Covered_Blue",
									"Exile_Car_Ural_Covered_Yellow",
									"Exile_Car_Ural_Covered_Worker",
									"Exile_Car_Ural_Open_Blue",
									"Exile_Car_Ural_Open_Yellow",
									"Exile_Car_Ural_Open_Worker"
								];
_Possiblevehicleoffroad		=	[
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
								];

// Vehicle type has been chosen so lets now assign the list to be the one chosen from and chose the exact vehicle

switch (_Vehicletype) do
{
	case "Car":
	{
		_VehicleClass = selectRandom _Possiblevehiclecar;
	};
	case "LandRover":
	{
		_VehicleClass = selectRandom _Possiblevehiclelandrover;
	};
	case "Van":
	{
		_VehicleClass = selectRandom _Possiblevehiclevan;
	};
	case "Truck":
	{	
		_VehicleClass = selectRandom _Possiblevehicletruck;
	};
	//case "Off-Road":
	default
	{
		_VehicleClass = selectRandom _Possiblevehicleoffroad;
	};
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	
								"easy",
								"easy",
								"easy",
								"easy",
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
		_VehicleChance = 25;												//25% SpawnPersistentVehicle chance
		_cash = (250 + round (random (500)));								//this gives 250 to 750 cash
		_ned_VehicleItems = [["U_NikosAgedBody",1,0], ["U_NikosBody",1,1], ["H_Cap_press",1,0],["H_StrawHat_dark",1,0], ["Exile_Item_EMRE",1,1], ["Exile_Item_PlasticBottleCoffee",1,1], ["ItemGPS",1,0], ["hgun_Rook40_F",1,1], ["hgun_ACPC2_F",0,1], ["9Rnd_45ACP_Mag",1,1], ["16Rnd_9x21_Mag",1,1]];
	};
	case "moderate":
	{
		_AICount = (4 + (round (random 2)));
		_VehicleChance = 33;												//33% SpawnPersistentVehicle chance
		_cash = (500 + round (random (750)));								//this gives 500 to 1250 cash	
		_ned_VehicleItems = [["U_NikosAgedBody",1,1], ["U_NikosBody",1,2], ["H_Cap_press",1,1],["H_StrawHat_dark",1,1], ["Exile_Item_EMRE",1,2], ["Exile_Item_PlasticBottleCoffee",1,2], ["ItemGPS",1,1], ["hgun_Rook40_F",1,2], ["hgun_ACPC2_F",1,1], ["9Rnd_45ACP_Mag",2,2], ["16Rnd_9x21_Mag",2,2]];			
	};
	case "difficult":
	{
		_AICount = (5 + (round (random 3)));
		_VehicleChance = 50;												//50% SpawnPersistentVehicle chance
		_cash = (750 + round (random (1000)));								//this gives 750 to 1750 cash
		_ned_VehicleItems = [["U_NikosAgedBody",1,2], ["U_NikosBody",1,3], ["H_Cap_press",1,2],["H_StrawHat_dark",1,2], ["Exile_Item_EMRE",1,3], ["Exile_Item_PlasticBottleCoffee",1,3], ["ItemGPS",1,2], ["hgun_Rook40_F",1,3], ["hgun_ACPC2_F",1,2], ["9Rnd_45ACP_Mag",3,3], ["16Rnd_9x21_Mag",3,3]];
	};
	//case "hardcore":
	default
	{
		_AICount = (6 + (round (random 4)));
		_VehicleChance = 75;												//75% SpawnPersistentVehicle chance
		_cash = (1000 + round (random (1500)));								//this gives 1000 to 2500 cash
		_ned_VehicleItems = [["U_NikosAgedBody",1,3], ["U_NikosBody",1,4], ["H_Cap_press",1,3],["H_StrawHat_dark",1,3], ["Exile_Item_EMRE",1,4], ["Exile_Item_PlasticBottleCoffee",1,4], ["ItemGPS",1,3], ["hgun_Rook40_F",1,4], ["hgun_ACPC2_F",2,2], ["9Rnd_45ACP_Mag",4,4], ["16Rnd_9x21_Mag",4,4]];
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

// add vehicle patrol
_veh =
		[
			[
				[(_pos select 0) -75,(_pos select 1)+75,0]
			],
			_group,
			"assault",
			"easy",
			_side
		] call DMS_fnc_SpawnAIVehicle;

// add static guns
_staticGuns =
				[
					[
						// make statically positioned relative to centre point and randomise a little
						[(_pos select 0) -(5-(random 2)),(_pos select 1)+(5-(random 2)),0],
						[(_pos select 0) +(5-(random 2)),(_pos select 1)-(5-(random 2)),0]
					],
					_group,
					"assault",
					"static",
					"bandit"
				] call DMS_fnc_SpawnAIStaticMG;

// is %chance greater than random number
if (_VehicleChance >= (random 100)) then {
											_pinCode = (1000 +(round (random 8999)));
											_vehicle = [_VehicleClass,[(_pos select 0) -30, (_pos select 1) -30],_pinCode] call DMS_fnc_SpawnPersistentVehicle;
											_msgWIN = ['#0080ff',format ["Convicts killed the %1 and made off with the %2, entry code %3...",_Enemies,_Vehicletype,_pinCode]];
										} else
										{
											_vehicle = [_VehicleClass,[(_pos select 0) -30, (_pos select 1) -30]] call DMS_fnc_SpawnNonPersistentVehicle;
											_msgWIN = ['#0080ff',format ["Convicts killed the %1 and made off with the %1",_Enemies,_Vehicletype]];
										};

// no crate so load vehicle with basic goodies, good as we dont know what the vehicle is so keep list smaller.
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

// add cash to vehicle
_vehicle setVariable ["ExileMoney", _cash,true];										

// Define mission-spawned AI Units
_missionAIUnits =
					[
						_group 		// We only spawned the single group for this mission
					];

// Define mission-spawned objects and loot values
_missionObjs =
				[
					_staticGuns+[_veh],						// armed AI vehicle and static guns
					[_vehicle],								// this is prize vehicle
					[[]]										// no crate everything in vehicle
				];

// define start messages with difficulty choice
_msgStart = ['#FFFF00',format["%1 with a %2 have broken down. Find the %3 %1 and %4",_Enemies,_Vehicletype,_difficulty,_Dosomething]];

// Define Mission Win message in persistent choice

// Define Mission Lose message
_msgLOSE = ['#FF0000',format ["The %1 drove off and escaped with the %2.",_Enemies,_Vehicletype]];

// Define mission name (for map marker and logging)
_missionName = ['#FF0000',format ["%1 %2",_Enemies,_Vehicletype]];

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