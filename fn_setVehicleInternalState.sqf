params ["_vehicle", "_internalState"];
scopeName "main";

_damage = _internalState select 0;
_hitPointsDamage = _internalState select 1;
_fuel = _internalState select 2;
_fuelCargo = _internalState select 3;
_ammoCargo = _internalState select 4;
_repairCargo = _internalState select 5;
_weaponsCargo = _internalState select 6;
_magazinesCargo = _internalState select 7;
_itemsCargo = _internalState select 8;
_backpacksCargo = _internalState select 9;

_vehicle setDamage _damage;

if (3 <= count _hitPointsDamage) then {
	_hitpointNames = _hitPointsDamage select 0;
	_selectionNames = _hitPointsDamage select 1;
	_damageValues = _hitPointsDamage select 2;

	for [{_d = 0}, {_d < count _damageValues}, {_d = _d + 1}] do {
		_hitpointName = _hitpointNames select _d;
		_selectionName = _selectionNames select _d;
		_damageValue = _damageValues select _d;
		if (_hitpointName != "") then {
			_vehicle setHitPointDamage [_hitpointName, _damageValue];
		};
		if (_selectionName != "") then {
			_vehicle setHit [_selectionName, _damageValue];
		};
	};
};

_vehicle setFuel _fuel;

_vehicle setFuelCargo _fuelCargo;

_vehicle setAmmoCargo _ammoCargo;

_vehicle setRepairCargo _repairCargo;

clearWeaponCargoGlobal _vehicle;
for [{_c = 0}, {_c < count _weaponsCargo}, {_c = _c + 1}] do {
	_weaponsCargoElem = _weaponsCargo select _c;
	_vehicle addWeaponWithAttachmentsCargoGlobal [_weaponsCargoElem, 1];
};

clearMagazineCargoGlobal _vehicle;
for [{_c = 0}, {_c < count _magazinesCargo}, {_c = _c + 1}] do {
	_magazinesCargoElem = _magazinesCargo select _c;
	_magazinesCargoElemClass = _magazinesCargoElem select 0;
	_magazinesCargoElemAmmo = _magazinesCargoElem select 1;
    _vehicle addMagazineAmmoCargo [_magazinesCargoElemClass, 1, _magazinesCargoElemAmmo];
};

clearItemCargoGlobal _vehicle;
_itemsCargoClasses = _itemsCargo select 0;
_itemsCargoCounts = _itemsCargo select 1;
for [{_c = 0}, {_c < count _itemsCargoClasses}, {_c = _c + 1}] do {
	_itemsCargoClass = _itemsCargoClasses select _c;
	_itemsCargoCount = _itemsCargoCounts select _c;
	_vehicle addItemCargoGlobal [_itemsCargoClass, _itemsCargoCount];
};

clearBackpackCargoGlobal _vehicle;
_backpacksCargoClasses = _backpacksCargo select 0;
_backpacksCargoCounts = _backpacksCargo select 1;
for [{_c = 0}, {_c < count _backpacksCargoClasses}, {_c = _c + 1}] do {
	_backpacksCargoClass = _backpacksCargoClasses select _c;
	_backpacksCargoCount = _backpacksCargoCounts select _c;
	_vehicle addBackpackCargoGlobal [_backpacksCargoClass, _backpacksCargoCount];
};
