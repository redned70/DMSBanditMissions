/*
	Sniper Camp Mission with new difficulty selection system
	Mission gives % chance of persistent vehicle
	based on work by Defent and eraser1
	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
	now with rocket and mine chance - mines cleaned on mission win - updated June 2018
*/

private ["_num", "_side", "_pos", "_OK", "_difficulty", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_crate1", "_vehicle", "_pinCode", "_class", "_veh", "_crate_loot_values1", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_crate_weapons", "_crate_weapon_list", "_crate_items", "_crate_item_list", "_crate_backpacks", "_PossibleDifficulty", "_VehicleChance", "_RocketChance", "_MineChance1", "_MineNumber1", "_MineRadius1", "_Minefield1", "_cleanMines1", "_temp", "_temp2", "_temp3", "_logLauncher"];

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
					_AICount 			= (4 + (round (random 4)));
					_VehicleChance 		= 10;											//10% SpawnPersistentVehicle chance
					_crate_weapons 		= (4 + (round (random 2)));
					_crate_weapon_list	= ["arifle_MXM_Black_F","srifle_DMR_01_F","srifle_EBR_F","srifle_GM6_camo_F","srifle_LRR_camo_F"];
					_crate_items 		= (8 + (round (random 3)));
					_crate_item_list	= ["10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","100Rnd_65x39_caseless_mag","10Rnd_127x54_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_mag","30Rnd_556x45_Stanag"];
					_crate_backpacks 	= (1 + (round (random 1)));
					_RocketChance 		= -1;											// no rockets on easy - this overrides DMS config
					_MineChance1 		= -1;											// no mines on easy - this overrides DMS config
					_MineNumber1 		= (3 + (round (random 5)));						// don't really need this if chance = -1 but here for changes if needed
					_MineRadius1 		= (30 + (round (random 15)));					// don't really need this if chance = -1 but here for changes if needed
				};
	case "moderate":
				{
					_AICount 			= (6 + (round (random 4)));
					_VehicleChance 		= 20;											//20% SpawnPersistentVehicle chance
					_crate_weapons 		= (6 + (round (random 2)));
					_crate_weapon_list	= ["arifle_MXM_Black_F","srifle_DMR_01_F","srifle_EBR_F","srifle_GM6_camo_F","srifle_LRR_camo_F"];
					_crate_items 		= (10 + (round (random 3)));
					_crate_item_list	= ["10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","100Rnd_65x39_caseless_mag","10Rnd_127x54_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_mag","30Rnd_556x45_Stanag"];
					_crate_backpacks 	= (2 + (round (random 1)));
					_RocketChance 		= 5;											// 5% chance of rockets - this overrides DMS config
					_MineChance1 		= 5;											// 5% chance of mines - this overrides DMS config
					_MineNumber1 		= (5 + (round (random 10)));					// 5 to 15 mines can spawn if triggered
					_MineRadius1 		= (40 + (round (random 25)));					// radius around center point is 40 to 65
				};
	case "difficult":
				{
					_AICount 			= (8 + (round (random 4)));
					_VehicleChance 		= 30;											//30% SpawnPersistentVehicle chance
					_crate_weapons 		= (9 + (round (random 2)));
					_crate_weapon_list	= ["srifle_DMR_03_khaki_F","srifle_DMR_03_tan_F","srifle_DMR_03_woodland_F","srifle_DMR_05_blk_F","srifle_DMR_05_hex_F","srifle_DMR_06_camo_F","srifle_DMR_06_olive_F","srifle_EBR_F","srifle_GM6_camo_F","srifle_LRR_camo_F"];
					_crate_items 		= (14 + (round (random 3)));
					_crate_item_list	= ["10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","100Rnd_65x39_caseless_mag","10Rnd_127x54_Mag","16Rnd_9x21_Mag","100Rnd_65x39_caseless_mag","10Rnd_127x54_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_mag","30Rnd_556x45_Stanag"];
					_crate_backpacks 	= (3 + (round (random 1)));
					_RocketChance 		= 25; 											// 25% chance of rockets - this overrides DMS config
					_MineChance1 		= 25; 											// 25% chance of mines - this overrides DMS config
					_MineNumber1 		= (8 + (round (random 12)));  					// 8 to 20 mines can spawn if triggered
					_MineRadius1 		= (50 + (round (random 30))); 					// radius around center point is 50 to 80
				};
	//case "hardcore":
	default
				{
					_AICount 		= (8 + (round (random 8)));
					_VehicleChance 		= 90;											//90% SpawnPersistentVehicle chance
					_crate_weapons 		= (14 + (round (random 2)));
					_crate_weapon_list	= ["srifle_DMR_02_camo_F","srifle_DMR_02_sniper_F","srifle_DMR_03_khaki_F","srifle_DMR_03_multicam_F","srifle_DMR_03_woodland_F","srifle_DMR_04_F","srifle_DMR_04_Tan_F","srifle_DMR_05_blk_F","srifle_DMR_05_hex_F","srifle_DMR_05_tan_f","srifle_DMR_06_camo_F","srifle_DMR_06_olive_F","srifle_EBR_F","srifle_GM6_camo_F","srifle_LRR_camo_F"];
					_crate_items 		= (17 + (round (random 3)));
					_crate_item_list	= ["10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","10Rnd_93x64_DMR_05_Mag","100Rnd_65x39_caseless_mag","10Rnd_127x54_Mag","16Rnd_9x21_Mag","100Rnd_65x39_caseless_mag","10Rnd_127x54_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_mag","16Rnd_9x21_Mag","100Rnd_65x39_caseless_mag","10Rnd_127x54_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_mag","30Rnd_556x45_Stanag"];
					_crate_backpacks 	= (4 + (round (random 1)));
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

// Hardcore needs different settings for AI
if (_difficulty isEqualTo "hardcore") then {
_group = 	[
				[[(_pos select 0)+3,(_pos select 1)-3,0],[(_pos select 0)+(10+(random 20)),(_pos select 1)+(10+(random 20)),0]],					// Position AI in tent + 2nd squad
				_AICount,					// Number of AI
				_difficulty,				// "random","hardcore","difficult","moderate", or "easy"
				"sniper", 					// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
				_side 						// "bandit","hero", etc.
			] call DMS_fnc_SpawnAIGroup_MultiPos;
											} else
											{
_group = 	[
				[(_pos select 0)+3,(_pos select 1)-3,0],					// Position AI in tent
				_AICount,				// Number of AI
				_difficulty,			// "random","hardcore","difficult","moderate", or "easy"
				"sniper", 				// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
				_side 					// "bandit","hero", etc.
			] call DMS_fnc_SpawnAIGroup;
											};

// add vehicle patrol and randomise a little - same for all levels (as it uses variable)
_veh = 	[
			[
				[(_pos select 0) -(75-(random 25)),(_pos select 1) +(75+(random 25)),0]
			],
			_group,
			"assault",
			_difficulty,
			_side
		] call DMS_fnc_SpawnAIVehicle;

// add static guns - same for all levels
_staticGuns = 	[
					[
						// make statically positioned relative to centre point and randomise a little
						[(_pos select 0) -(5-(random 1)),(_pos select 1)+(5-(random 1)),0],
						[(_pos select 0) +(5-(random 1)),(_pos select 1)-(5-(random 1)),0]
					],
					_group,
					"assault",
					"static",
					"bandit"
				] call DMS_fnc_SpawnAIStaticMG;

// Create Buildings - use seperate file as found in the mercbase mission - same for all levels
_baseObjs = 	[
					"nedsnipercamp_objects",
					_pos
				] call DMS_fnc_ImportFromM3E;

// is %chance greater than random number
if (_VehicleChance >= (random 100)) then {
											_pinCode = (1000 +(round (random 8999)));
											_vehicle = ["Exile_Car_Ural_Covered_Military",[(_pos select 0) +17.2, (_pos select 1) -0],_pinCode] call DMS_fnc_SpawnPersistentVehicle;
											_msgWIN = ['#0080ff',format ["Convicts have killed the snipers and stolen their rifles,the truck code is %1...",_pinCode]];
										} else
										{
											_vehicle = ["Exile_Car_Ural_Covered_Military",[(_pos select 0) +17.2, (_pos select 1) -0,0],[], 0, "CAN_COLLIDE"] call DMS_fnc_SpawnNonPersistentVehicle;
											_msgWIN = ['#0080ff',"Convicts have killed the snipers and stolen their rifles"];
										};

// Create Crate type - same for all levels
_crate1 = ["Box_NATO_Wps_F",_pos] call DMS_fnc_SpawnCrate;

// setup crate itself with items - same for all levels
_crate_loot_values1 = 	[
							[_crate_weapons,_crate_weapon_list],		// Weapons
							[_crate_items,_crate_item_list],			// Items + selection list
							_crate_backpacks 							// Backpacks
						];

// Define mission-spawned AI Units
_missionAIUnits = 	[
						_group 		// We only spawned the single group for this mission
					];

// Define mission-spawned objects and loot values
_missionObjs = 	[
					_staticGuns+_baseObjs+[_veh],			// armed AI vehicle, base objects, and static guns
					[_vehicle],								//this is prize vehicle
					[[_crate1,_crate_loot_values1]],
					_cleanMines1
				];

// Define Mission start message with difficulty level - choice due to "an" being required for "an easy" and "a" for rest
if (_difficulty isEqualTo "easy") then {
_msgStart = ['#FFFF00',format["Snipers have set up an %1 training camp, go steal their rifles",_difficulty]];
										} else
										{
_msgStart = ['#FFFF00',format["Snipers have set up a %1 training camp, go steal their rifles",_difficulty]];
										};

// Define Mission Win message - defined in choices

// Define Mission Lose message - same for all levels
_msgLOSE = ['#FF0000',"The Snipers have packed up and left, no rifles for you!"];

// Define mission name (for map marker and logging) - same for all levels
_missionName = "Sniper Camp";

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