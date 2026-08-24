params ["_vehicle"];
scopeName "main";

_damage = damage _vehicle;
_hitPointsDamage = getAllHitPointsDamage _vehicle;
_fuel = fuel _vehicle;
_fuelCargo = getFuelCargo _vehicle;
_ammoCargo = getAmmoCargo _vehicle;
_repairCargo = getRepairCargo _vehicle;
_weaponsCargo = weaponsItemsCargo [_vehicle, true];
_magazinesCargo = magazinesAmmoCargo _vehicle;
_itemsCargo = getItemCargo _vehicle;
_backpacksCargo = getBackpackCargo _vehicle;

_internalState = [
	_damage,
	_hitPointsDamage,
	_fuel,
	_fuelCargo,
	_ammoCargo,
	_repairCargo,
	_weaponsCargo,
	_magazinesCargo,
	_itemsCargo,
	_backpacksCargo
];
_internalState breakOut "main";
