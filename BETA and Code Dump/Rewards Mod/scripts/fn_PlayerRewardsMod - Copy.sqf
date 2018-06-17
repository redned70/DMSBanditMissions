/*
	DMS_fn_PlayerRewardsMod
	Created by [CiC]red_ned
	Requires Exile Rewards Mod - http://www.exilemod.com/topic/24883-exile-player-rewards/
	Function template by eraser1
	Add "class PlayerRewardsMod 			{};" to "class compiles" list in config.cpp to make it work
	Finds nearest player on command then applies rewards string

["addRewardsRequest", [getplayeruid player, [["ExileMoney",_cash],["ExileScore",_score],_crate_loot_values,[_prizevehicles]]] call ExileClient_system_network_send;	
	
	Usage:
	[
		_cash,								// whole numbers
		_score,								// whole numbers
		_crate_loot_values,					// (x,y,z) whole numbers
		_prizevehicles						// ["vehicle1","vehicle2"]
	] call DMS_fn_PlayerRewardsMod;


*/

private ["_playerObj", "_playerUID", "_crate" ];

if !(params
[
	"_cash",
	"_score",
	"_crate_loot_values",
	"_prizevehicles"
])
exitWith
{
	diag_log format ["DMS ERROR :: Calling DMS_fn_PlayerRewardsMod with invalid parameters: %1",_this];
};

// _playerUID = getPlayerUID _playerObj;


// logging a bit
diag_log format ["******************************************************************************"];
diag_log format ["fnc_DMS check :: DMS_fn_PlayerRewardsMod received from mission Cash:%1 Rep:%2 Crate:%3 Vehicle:%4", _cash, _score, _crate_loot_values, _prizevehicles];
diag_log format ["******************************************************************************"];


// find nearest player and get their UID
private _ns = 0;
while	{(_ns < 100)} do {
				if (count (_pos nearEntities [['Exile_Unit_Player'],_ns]) > 0) then 
					{ _playerUID 		=	(getPlayerUID (_pos nearEntities [['Exile_Unit_Player'],_ns]));} else	
					{	_ns = _ns + 1;
						_playerUID = "";
					};
			};

// If either cash or score is empty set to 0 to avoid errors before building reward string
if  ( _cash == "" ) then { _cash = 0; } else { _cash = _cash; };
if  ( _score == "" ) then { _score = 0; } else { _score = _score; };

// logging a bit
diag_log format ["******************************************************************************"];
diag_log format ["fnc_DMS check :: DMS_fn_PlayerRewardsMod generating Cash:%1 Rep:%2 playerUID:%3", _cash, _score, _playerUID];
diag_log format ["******************************************************************************"];


// need to use part of DMS_fnc_FillCrate to actually parse through prize objects so it functions the same as normal

if ((_lootValues isEqualType []) && {!((_lootValues select 1) isEqualType {})}) then
{
	// Weapons
	private _wepValues = _lootValues select 0;
	private _wepCount = 0;
	private _weps =
		if (_wepValues isEqualType []) then
		{
			_wepCount	= _wepValues select 0;
			_wepValues select 1
		}
		else
		{
			_wepCount	= _wepValues;
			DMS_boxWeapons
		};


	// Items
	private _itemValues = _lootValues select 1;
	private _itemCount = 0;
	private _items =
		if (_itemValues isEqualType []) then
		{
			_itemCount	= _itemValues select 0;
			_itemValues select 1
		}
		else
		{
			_itemCount	= _itemValues;
			DMS_boxItems
		};


	// Backpacks
	private _backpackValues = _lootValues select 2;
	private _backpackCount = 0;
	private _backpacks =
		if (_backpackValues isEqualType []) then
		{
			_backpackCount	= _backpackValues select 0;
			_backpackValues select 1
		}
		else
		{
			_backpackCount = _backpackValues;
			DMS_boxBackpacks
		};

	if (count _weps>0) then
	{
		// Add weapons + mags
		for "_i" from 1 to _wepCount do
		{
			private _weapon = selectRandom _weps;
			private _ammo = _weapon call DMS_fnc_selectMagazine;
			if (_weapon isEqualType "") then
			{
				_weapon = [_weapon,1];
			};
			_crate  = _crate + _weapon;
			if !(_ammo in ["Exile_Magazine_Swing","Exile_Magazine_Boing","Exile_Magazine_Swoosh"]) then
			{
				_crate  = _crate + [_ammo, (DMS_MinimumMagCount + floor(random DMS_MagRange))];
			};
		};
	};


	if (count _items>0) then
	{
		// Add items
		for "_i" from 1 to _itemCount do
		{
			private _item = selectRandom _items;
			if (_item isEqualType "") then
			{
				_item = [_item,1];
			};
			_crate  = _crate + _item;
		};
	};


	if (count _backpacks>0) then
	{
		// Add backpacks
		for "_i" from 1 to _backpackCount do
		{
			private _backpack = selectRandom _backpacks;
			if (_backpack isEqualType "") then
			{
				_backpack = [_backpack,1];
			};
			_crate  = _crate + _backpack;
		};
	};
}
else
{
	private _crateValues =
		if (_lootValues isEqualType []) then
		{
			(_lootValues select 0) call (_lootValues select 1)
		}
		else
		{
			missionNamespace getVariable (format ["DMS_CrateCase_%1",_lootValues])
		};

	if !((_crateValues params
	[
		"_weps",
		"_items",
		"_backpacks"
	]))
	exitWith
	{
		diag_log format ["DMS ERROR :: Invalid ""_crateValues"" (%1) generated from _lootValues: %2",_crateValues,_lootValues];
	};

	// Weapons
	{
		if (_x isEqualType "") then
		{
			_x = [_x,1];
		};
		_crate  = _crate + _x;
	} forEach _weps;

	// Items/Mags
	{
		if (_x isEqualType "") then
		{
			_x = [_x,1];
		};
		_crate  = _crate + _x;
	} forEach _items;

	// Backpacks
	{
		if (_x isEqualType "") then
		{
			_x = [_x,1];
		};
		_crate  = _crate + _x;
	} forEach _backpacks;

if (DMS_RareLoot) then
{
	private _rareLootChance =
		if ((count _this)>2) then
		{
			_this param [2,DMS_RareLootChance,[0]]
		}
		else
		{
			DMS_RareLootChance
		};

	// (Maybe) Add rare loot
	if(random 100 < _rareLootChance) then
	{
		for "_i" from 1 to DMS_RareLootAmount do
		{
			_item = selectRandom DMS_RareLootList;
			if (_item isEqualType "") then
			{
				_item = [_item,1];
			};
			_crate = _crate + _item;
		};
	};
};

if ((!isNull _playerObj) && {(_playerUID != "") && {_playerObj isKindOf "Exile_Unit_Player"}}) then
{

	["addRewardsRequest", 	[
								_playerUID, 
								[
									["ExileMoney",_cash],
									["ExileScore",_score],
									[_crate],
									[_prizevehicle]
								]
							]
	] call ExileClient_system_network_send;	
};


// logging a bit
diag_log format ["******************************************************************************"];
diag_log format ["fnc_DMS check :: DMS_fn_PlayerRewardsMod generating addRewardsRequest playerUID:%1 ExileMoney:%2 ExileScore:%3 CrateItems:%4 Vehicle:%5", _playerUID, _cash, _score, _crate, _prizevehicle];
diag_log format ["******************************************************************************"];


	if (DMS_DEBUG) then
	{
		format ["DMS_fn_PlayerRewardsMod :: %1 (%2) awarded %3 poptabs and %4 respect for completing mission. Prizes included %5 loot items and %6 vehicles", name _playerObj, _playerUID, _cash, _score,_crate_loot_values,_prizevehicle] call DMS_fnc_DebugLog;
	};
}
else
{
	if (DMS_DEBUG) then
	{
		format ["DMS_fn_PlayerRewardsMod :: No reward for non-player _playerObj: %1",_playerObj] call DMS_fnc_DebugLog;
	};
};