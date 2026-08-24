_vehicleTypes = [
	[[
        "rhs_kraz255b1_fuel_msv",
        "RHS_Ural_Fuel_MSV_01"
	], 1]
];
_chunkSize = 200;
_baseScoreBias = 0.0005;
_housesScoreYCoef = 0;
_housesScoreXCoef = 0;
_roadsScoreYCoef = 1;
_roadsScoreXCoef = 0.1;
_heightScoreYCoef = -0.005;
_heightScoreXCoef = 0.002;
_waterScoreBias = -1;
_safeZoneBias = -1;
_dangerZoneBias = 0;
_militaryZoneBias = -0.001;
_safeZones = [
	["base_zone", _safeZoneBias]
];
_dangerZones = [
];
_militaryZones = [
	["military_zone_0", _militaryZoneBias],
	["military_zone_1", _militaryZoneBias],
	["military_zone_2", _militaryZoneBias],
	["military_zone_3", _militaryZoneBias],
	["military_zone_4", _militaryZoneBias]
];

_allZones = _safeZones + _dangerZones + _militaryZones;
_vehiclesTotal = 3;
_housePosProb = 0;
_roadPosProb = 0.9;
_otherPosProb = 0.1;
_renderRefreshPeriod = 5;
_renderMinRadius = 100;
_renderMaxRadius = 2000;
_dirtyDistance = 5;
_fn_initObj = {
    params ["_vehicle"];
    _vehicle setFuel random [0, 0.5, 1];
    _allParts = (getAllHitPointsDamage _vehicle) select 0;
    {
        _damage = random [0, 0.3, 0.9];
        _vehicle setHitPointDamage [_x, _damage];
    } forEach _allParts;
};

_logsEnabled = false;
_markersEnabled = false;
_markerType = "o_maint";
_color = "ColorCIV";

[
    _vehicleTypes,
    _chunkSize,
	_baseScoreBias,
    _housesScoreYCoef,
    _housesScoreXCoef,
    _roadsScoreYCoef,
    _roadsScoreXCoef,
	_heightScoreYCoef,
	_heightScoreXCoef,
    _waterScoreBias,
    _allZones,
    _vehiclesTotal,
    _housePosProb,
    _roadPosProb,
    _otherPosProb,
    _renderRefreshPeriod,
    _renderMinRadius,
    _renderMaxRadius,
	_dirtyDistance,
    _fn_initObj,
    _logsEnabled,
    _markersEnabled,
    _markerType,
    _color
] spawn fn_runVehiclesThread;
