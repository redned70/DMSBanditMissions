/*
	Hijacked Ikea Trader Mission with new difficulty selection system
	Mission gives % chance of persistent vehicle
	based on work by Defent and eraser1 and Ikea convoy from WAI missions
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

private ["_num", "_side", "_pos", "_OK", "_difficulty", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_crate1", "_vehicle", "_pinCode", "_class", "_veh", "_crate_loot_values1", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_ned_VehicleItems", "_PossibleDifficulty", "_VehicleChance", "_cash"];

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
	diag_log format ["DMS ERROR :: Called MISSION nedsnipercamp_mission.sqf with invalid parameters: %1",_this];
};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	
								"easy",
								"easy",
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
_AICount = (4 + (round (random 4)));
_VehicleChance = 10;												//10% SpawnPersistentVehicle chance
_ned_VehicleItems = [["Exile_Item_ExtensionCord",1,0], ["Exile_Item_DuctTape",1,1], ["Exile_Item_LightBulb",1,0],["Exile_Item_MetalBoard",1,1], ["Exile_Item_MetalPole",1,1], ["Exile_Melee_SledgeHammmer",0,1], ["Exile_Item_Handsaw",1,0], ["Exile_Item_Pliers",1,1], ["Exile_Item_Grinder",0,1], ["Exile_Item_WoodDoorKit",1,1], ["Exile_Item_WoodDoorwayKit",0,1], ["Exile_Item_WoodFloorKit",1,1], ["Exile_Item_WoodGateKit",1,1], ["Exile_Item_WoodSupportKit",1,1], ["Exile_Item_WoodWallKit",1,1], ["Exile_Item_WoodWindowKit",1,1], ["Exile_Item_MetalHedgehogKit",0,1]];
_cash = (250 + round (random (500)));								//cash prize
	};
	case "moderate":
	{
_AICount = (6 + (round (random 4)));
_VehicleChance = 20;												//20% SpawnPersistentVehicle chance
_ned_VehicleItems = [["Exile_Item_ExtensionCord",1,0], ["Exile_Item_DuctTape",1,1], ["Exile_Item_LightBulb",1,0],["Exile_Item_MetalBoard",1,1], ["Exile_Item_MetalPole",1,1], ["Exile_Melee_SledgeHammmer",1,1], ["Exile_Item_Handsaw",1,0], ["Exile_Item_Pliers",1,1], ["Exile_Item_Grinder",0,1], ["Exile_Item_WoodDoorKit",1,1], ["Exile_Item_WoodDoorwayKit",1,1], ["Exile_Item_WoodFloorKit",1,2], ["Exile_Item_WoodGateKit",1,1], ["Exile_Item_WoodStairsKit",1,1], ["Exile_Item_WoodSupportKit",1,1], ["Exile_Item_WoodWallKit",1,2], ["Exile_Item_WoodWindowKit",1,1], ["Exile_Item_MetalHedgehogKit",1,1]];
_cash = (500 + round (random (750)));								//cash prize
	};
	case "difficult":
	{
_AICount = (8 + (round (random 4)));
_VehicleChance = 30;												//30% SpawnPersistentVehicle chance
_ned_VehicleItems = [["Exile_Item_ExtensionCord",1,0], ["Exile_Item_DuctTape",1,2], ["Exile_Item_LightBulb",1,2],["Exile_Item_MetalBoard",1,3], ["Exile_Item_MetalPole",1,1], ["Exile_Melee_SledgeHammmer",1,1], ["Exile_Item_Handsaw",1,0], ["Exile_Item_Pliers",1,1], ["Exile_Item_Grinder",1,1], ["Exile_Item_WoodDoorKit",1,2], ["Exile_Item_WoodDoorwayKit",0,1], ["Exile_Item_ConcreteFloorKit",1,1], ["Exile_Item_WoodGateKit",1,1], ["Exile_Item_WoodStairsKit",1,2], ["Exile_Item_WoodSupportKit",1,2], ["Exile_Item_WoodWallKit",1,2], ["Exile_Item_WoodWindowKit",1,2], ["Exile_Item_MetalHedgehogKit",1,1], ["Exile_Item_SafeKit",0,1]];
_cash = (750 + round (random (1000)));								//cash prize
	};
	//case "hardcore":
	default
	{
_AICount = (8 + (round (random 8)));
_VehicleChance = 90;												//90% SpawnPersistentVehicle chance
_ned_VehicleItems = [["Exile_Item_ExtensionCord",1,1], ["Exile_Item_DuctTape",1,3], ["Exile_Item_LightBulb",1,2],["Exile_Item_MetalBoard",1,3], ["Exile_Item_MetalPole",1,3], ["Exile_Melee_SledgeHammmer",1,1], ["Exile_Item_Handsaw",1,0], ["Exile_Item_Pliers",1,1], ["Exile_Item_Grinder",1,1], ["Exile_Item_WoodDoorKit",1,2], ["Exile_Item_ConcreteDoorwayKit",1,1], ["Exile_Item_ConcreteFloorKit",1,1], ["Exile_Item_ConcreteGateKit",1,1], ["Exile_Item_ConcreteStairsKit",1,1], ["Exile_Item_ConcreteSupportKit",1,1], ["Exile_Item_ConcreteWallKit",1,1], ["Exile_Item_WoodWindowKit",1,1], ["Exile_Item_MetalHedgehogKit",1,2], ["Exile_Item_SafeKit",1,0]];
_cash = (1000 + round (random (1500)));								//cash prize					
	};
};

// Spawn AI
_group =
[
	[(_pos select 0)+(random 3),(_pos select 1)-(random 3),0],					// Position of AI
	_AICount,																	// Number of AI
	_difficulty,																// "random","hardcore","difficult","moderate", or "easy"
	"random", 																	// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
	_side 																		// "bandit","hero", etc.
] call DMS_fnc_SpawnAIGroup;

// add vehicle patrol and randomise a little - same for all levels (as it uses variable)
_veh =
[
	[
[(_pos select 0) -(75-(random 25)),(_pos select 1) +(75+(random 25)),0]
	],
	_group,
	"assault",
	_difficulty,
	_side
] call DMS_fnc_SpawnAIVehicle;

// add static guns - same for all levels
_staticGuns =
[
	[
		// make statically positioned relative to centre point and randomise a little
		[(_pos select 0) + 0.1, (_pos select 1) + 20, 0],
		[(_pos select 0) + 0.1, (_pos select 1) - 20, 0]
	],
	_group,
	"assault",
	"static",
	"bandit"
] call DMS_fnc_SpawnAIStaticMG;

// Create Buildings - use seperate file as found in the mercbase mission - same for all levels
_baseObjs =
[
	"nedtrader_objects",
	_pos
] call DMS_fnc_ImportFromM3E;

// Make buildings flat on terrain surface
{ _x setVectorUp surfaceNormal position _x; } count _baseObjs;

// is %chance greater than random number
if (_VehicleChance >= (random 100)) then {
											_pinCode = (1000 +(round (random 8999)));
											_vehicle = ["Exile_Car_Ural_Open_Worker",[(_pos select 0) +17.2, (_pos select 1) -0],_pinCode] call DMS_fnc_SpawnPersistentVehicle;
											_msgWIN = ['#0080ff',format ["Convicts have killed the bandits and stolen the supplies,the truck code is %1...",_pinCode]];	
										} else
										{
											_vehicle = ["Exile_Car_Ural_Open_Worker",[(_pos select 0) +17.2, (_pos select 1) -0,0],[], 0, "CAN_COLLIDE"] call DMS_fnc_SpawnNonPersistentVehicle;
											_msgWIN = ['#0080ff',"Convicts have killed the bandits and stolen the suplies"];
										};

// no crate so load vehicle with goodies
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

// load tabs in vehicle
_vehicle setVariable ["ExileMoney", _cash,true]; 

// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

// Define mission-spawned objects and loot values
_missionObjs =
[
	_staticGuns+_baseObjs+[_veh],			// armed AI vehicle, base objects, and static guns
	[_vehicle],								// this is prize vehicle
	[]										// no crate
];

// Define Mission Win message
_msgStart = ['#FFFF00',format["%1 Bandits are raiding an Ikea travelling trader",_difficulty]];	

// Define Mission Lose message - same for all levels
_msgLOSE = ['#FF0000',"The Bandits have left with all the building supplies"];

// Define mission name (for map marker and logging) - same for all levels
_missionName = "Hijacked Ikea Trader";

// Create Markers - same for all levels
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