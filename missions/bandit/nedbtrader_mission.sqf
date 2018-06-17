/*
	Hijacked Ikea Trader Mission with new difficulty selection system
	Mission gives % chance of persistent vehicle
	based on work by Defent and eraser1 and Ikea convoy from WAI missions
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
	now with rocket and mine chance - mines cleaned on mission win - updated June 2018
*/

private ["_num", "_side", "_pos", "_OK", "_difficulty", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_crate1", "_vehicle", "_pinCode", "_class", "_veh", "_crate_loot_values1", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_ned_VehicleItems", "_PossibleDifficulty", "_VehicleChance", "_cash", "_vehClass", "_ArmedVehicles", "_unArmedVehicles", "_RocketChance", "_MineChance1", "_MineNumber1", "_MineRadius1", "_Minefield1", "_cleanMines1", "_temp", "_temp2", "_temp3", "_logLauncher"];

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
	diag_log format ["DMS ERROR :: Called MISSION nedbtrader_mission.sqf with invalid parameters: %1",_this];
};

//doing bespoke AI vehicles
_ArmedVehicles =	[							// List of armed vehicles that can spawn
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
					];
_unArmedVehicles =	[							// List of unarmed vehicles that can spawn
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
					_vehClass = selectRandom _unArmedVehicles;
					_RocketChance 		= -1;											// no rockets on easy - this overrides DMS config
					_MineChance1 		= -1;											// no mines on easy - this overrides DMS config
					_MineNumber1 		= (3 + (round (random 5)));						// don't really need this if chance = -1 but here for changes if needed
					_MineRadius1 		= (30 + (round (random 15)));					// don't really need this if chance = -1 but here for changes if needed
				};
	case "moderate":
				{
					_AICount = (6 + (round (random 4)));
					_VehicleChance = 20;												//20% SpawnPersistentVehicle chance
					_ned_VehicleItems = [["Exile_Item_ExtensionCord",1,0], ["Exile_Item_DuctTape",1,1], ["Exile_Item_LightBulb",1,0],["Exile_Item_MetalBoard",1,1], ["Exile_Item_MetalPole",1,1], ["Exile_Melee_SledgeHammmer",1,1], ["Exile_Item_Handsaw",1,0], ["Exile_Item_Pliers",1,1], ["Exile_Item_Grinder",0,1], ["Exile_Item_WoodDoorKit",1,1], ["Exile_Item_WoodDoorwayKit",1,1], ["Exile_Item_WoodFloorKit",1,2], ["Exile_Item_WoodGateKit",1,1], ["Exile_Item_WoodStairsKit",1,1], ["Exile_Item_WoodSupportKit",1,1], ["Exile_Item_WoodWallKit",1,2], ["Exile_Item_WoodWindowKit",1,1], ["Exile_Item_MetalHedgehogKit",1,1]];
					_cash = (500 + round (random (750)));								//cash prize
					_vehClass = selectRandom _unArmedVehicles;
					_RocketChance 		= 5;											// 5% chance of rockets - this overrides DMS config
					_MineChance1 		= 5;											// 5% chance of mines - this overrides DMS config
					_MineNumber1 		= (5 + (round (random 10)));					// 5 to 15 mines can spawn if triggered
					_MineRadius1 		= (40 + (round (random 25)));					// radius around center point is 40 to 65
				};
	case "difficult":
				{
					_AICount = (8 + (round (random 4)));
					_VehicleChance = 30;												//30% SpawnPersistentVehicle chance
					_ned_VehicleItems = [["Exile_Item_ExtensionCord",1,0], ["Exile_Item_DuctTape",1,2], ["Exile_Item_LightBulb",1,2],["Exile_Item_MetalBoard",1,3], ["Exile_Item_MetalPole",1,1], ["Exile_Melee_SledgeHammmer",1,1], ["Exile_Item_Handsaw",1,0], ["Exile_Item_Pliers",1,1], ["Exile_Item_Grinder",1,1], ["Exile_Item_WoodDoorKit",1,2], ["Exile_Item_WoodDoorwayKit",0,1], ["Exile_Item_ConcreteFloorKit",1,1], ["Exile_Item_WoodGateKit",1,1], ["Exile_Item_WoodStairsKit",1,2], ["Exile_Item_WoodSupportKit",1,2], ["Exile_Item_WoodWallKit",1,2], ["Exile_Item_WoodWindowKit",1,2], ["Exile_Item_MetalHedgehogKit",1,1], ["Exile_Item_SafeKit",0,1]];
					_cash = (750 + round (random (1000)));								//cash prize
					_vehClass = selectRandom _ArmedVehicles;
					_RocketChance 		= 25; 											// 25% chance of rockets - this overrides DMS config
					_MineChance1 		= 25; 											// 25% chance of mines - this overrides DMS config
					_MineNumber1 		= (8 + (round (random 12)));  					// 8 to 20 mines can spawn if triggered
					_MineRadius1 		= (50 + (round (random 30))); 					// radius around center point is 50 to 80
				};
	//case "hardcore":
	default
				{
					_AICount = (8 + (round (random 8)));
					_VehicleChance = 90;												//90% SpawnPersistentVehicle chance
					_ned_VehicleItems = [["Exile_Item_ExtensionCord",1,1], ["Exile_Item_DuctTape",1,3], ["Exile_Item_LightBulb",1,2],["Exile_Item_MetalBoard",1,3], ["Exile_Item_MetalPole",1,3], ["Exile_Melee_SledgeHammmer",1,1], ["Exile_Item_Handsaw",1,0], ["Exile_Item_Pliers",1,1], ["Exile_Item_Grinder",1,1], ["Exile_Item_WoodDoorKit",1,2], ["Exile_Item_ConcreteDoorwayKit",1,1], ["Exile_Item_ConcreteFloorKit",1,1], ["Exile_Item_ConcreteGateKit",1,1], ["Exile_Item_ConcreteStairsKit",1,1], ["Exile_Item_ConcreteSupportKit",1,1], ["Exile_Item_ConcreteWallKit",1,1], ["Exile_Item_WoodWindowKit",1,1], ["Exile_Item_MetalHedgehogKit",1,2], ["Exile_Item_SafeKit",1,0]];
					_cash = (1000 + round (random (1500)));								//cash prize
					_vehClass = selectRandom _ArmedVehicles;
					_RocketChance 		= 50;											// 50% chance of rockets - this overrides DMS config
					_MineChance1 		= 50;											// 50% chance of mines - this overrides DMS config
					_MineNumber1 		= (10 + (round (random 15)));  					// 10 to 25 mines can spawn if triggered
					_MineRadius1 		= (60 + (round (random 40))); 					// radius around center point is 60 to 100
				};
};

//testing mechanics
					//_RocketChance = 100;
					//_MineChance1 = 100;

// Possible Minefield Position = _pos; but randomised
_Minefield1 = [(_pos select 0) -(5+(random 5)),(_pos select 1)+(5+(random 5)),(_pos select 2)];

//add launchers if chance great enough
if (_RocketChance >= (random 100)) then {
											_temp = DMS_ai_use_launchers;
											DMS_ai_use_launchers = true;					// Turn on launchers - ignore DMS-Config
											_temp2 = DMS_ai_use_launchers_chance;
											DMS_ai_use_launchers_chance = 100;				// %chance already done so ignore DMS-Config
											_logLauncher = "1";								// Test logging, can turn off
										} else
										{
											_temp = DMS_ai_use_launchers;
											DMS_ai_use_launchers = false;					// Turn off launchers - ignore DMS-Config
											_temp2 = DMS_ai_use_launchers_chance;
											DMS_ai_use_launchers_chance = 0;				// %chance already done so ignore DMS-Config
											_logLauncher = "0";								// Test logging, can turn off
										};

// Make sure mine clean up is on, but we will handle it too
_temp3 = DMS_despawnMines_onCompletion;
DMS_despawnMines_onCompletion = true;

//add minefields if chance great enough
if (_MineChance1 >= (random 100)) then 	{
							_cleanMines1 = 		[
													_Minefield1,
													_difficulty,
													[_MineNumber1,_MineRadius1],
													_side
												] call DMS_fnc_SpawnMinefield;
										} else
										{
							_cleanMines1 = [];
										};

// Spawn AI
_group = 	[
				[(_pos select 0)+(random 3),(_pos select 1)-(random 3),0],					// Position of AI
				_AICount,																	// Number of AI
				_difficulty,																// "random","hardcore","difficult","moderate", or "easy"
				"random", 																	// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
				_side 																		// "bandit","hero", etc.
			] call DMS_fnc_SpawnAIGroup;

// add vehicle patrol and randomise a little - same for all levels (as it uses variable)
_veh = 	[
			[
				[(_pos select 0) -(75-(random 25)),(_pos select 1) +(75+(random 25)),0]
			],
			_group,
			"assault",
			_difficulty,
			_side,
			_vehClass
		] call DMS_fnc_SpawnAIVehicle;

// add static guns - same for all levels
_staticGuns = 	[
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
_baseObjs = 	[
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
_missionAIUnits = 	[
						_group 		// We only spawned the single group for this mission
					];

// Define mission-spawned objects and loot values
_missionObjs = 	[
					_staticGuns+_baseObjs+[_veh],			// armed AI vehicle, base objects, and static guns
					[_vehicle],								// this is prize vehicle
					[],
					_cleanMines1										// no crate
				];

// Define Mission Win message
_msgStart = ['#FFFF00',format["%1 Bandits are raiding an Ikea travelling trader",_difficulty]];

// Define Mission Lose message - same for all levels
_msgLOSE = ['#FF0000',"The Bandits have left with all the building supplies"];

// Define mission name (for map marker and logging) - same for all levels
_missionName = "Hijacked Ikea Trader";

// logging for check purposes _missionName _cleanMines1 comment out if removed _logLauncher lines
diag_log format ["DMS Info :: Mission %1 , Mine cleanup %2 , Launchers %3 , minefield centered at %4",_missionName,_cleanMines1,_logLauncher,_Minefield1];

// Create Markers - same for all levels
_markers = 	[
				_pos,
				_missionName,
				_difficulty
			] call DMS_fnc_CreateMarker;

// Record time here (for logging purposes, otherwise you could just put "diag_tickTime" into the "DMS_AddMissionToMonitor" parameters directly)
_time = diag_tickTime;

// Parse and add mission info to missions monitor
_added = 	[
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