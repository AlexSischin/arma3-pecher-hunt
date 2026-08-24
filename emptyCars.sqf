_vehicleTypes = [
	[[
        "rhs_tigr_msv",
        "rhs_tigr_sts_msv",
        "rhs_tigr_m_msv",
        "RHS_UAZ_MSV_01",
        "rhs_uaz_open_MSV_01",
        "rhs_gaz66_msv",
        "rhs_gaz66o_msv",
        "rhs_gaz66_zu23_msv",
        "rhs_gaz66_ap2_msv",
        "rhs_kamaz5350_msv",
        "rhs_kraz255b1_bmkt_msv",
        "rhs_kraz255b1_cargo_open_msv",
        "rhs_kraz255b1_pmp_msv",
        "RHS_Ural_MSV_01",
        "RHS_Ural_Open_MSV_01",
        "RHS_Ural_Zu23_MSV_01",
        "rhs_zil131_msv",
        "rhs_zil131_open_msv"
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
	["monster_safe_zone_0", _safeZoneBias],
	["monster_safe_zone_1", _safeZoneBias]
];
_dangerZones = [
	["monster_danger_zone_0", _dangerZoneBias],
	["monster_danger_zone_1", _dangerZoneBias]
];
_militaryZones = [
	["military_zone_0", _militaryZoneBias],
	["military_zone_1", _militaryZoneBias],
	["military_zone_2", _militaryZoneBias],
	["military_zone_3", _militaryZoneBias],
	["military_zone_4", _militaryZoneBias],
	["military_zone_5", _militaryZoneBias],
	["military_zone_6", _militaryZoneBias],
	["military_zone_7", _militaryZoneBias],
	["military_zone_8", _militaryZoneBias],
	["military_zone_9", _militaryZoneBias],
	["military_zone_10", _militaryZoneBias],
	["military_zone_11", _militaryZoneBias],
	["military_zone_12", _militaryZoneBias],
	["military_zone_13", _militaryZoneBias],
	["military_zone_14", _militaryZoneBias],
	["military_zone_15", _militaryZoneBias],
	["military_zone_16", _militaryZoneBias],
	["military_zone_17", _militaryZoneBias],
	["military_zone_18", _militaryZoneBias],
	["military_zone_19", _militaryZoneBias],
	["military_zone_20", _militaryZoneBias],
	["military_zone_21", _militaryZoneBias],
	["military_zone_22", _militaryZoneBias],
	["military_zone_23", _militaryZoneBias],
	["military_zone_24", _militaryZoneBias],
	["military_zone_25", _militaryZoneBias],
	["military_zone_26", _militaryZoneBias],
	["military_zone_27", _militaryZoneBias],
	["military_zone_28", _militaryZoneBias],
	["military_zone_29", _militaryZoneBias],
	["military_zone_30", _militaryZoneBias],
	["military_zone_31", _militaryZoneBias],
	["military_zone_32", _militaryZoneBias],
	["military_zone_33", _militaryZoneBias],
	["military_zone_34", _militaryZoneBias],
	["military_zone_35", _militaryZoneBias],
	["military_zone_36", _militaryZoneBias],
	["military_zone_37", _militaryZoneBias],
	["military_zone_38", _militaryZoneBias],
	["military_zone_39", _militaryZoneBias],
	["military_zone_40", _militaryZoneBias]
];

_allZones = _safeZones + _dangerZones + _militaryZones;
_vehiclesTotal = 10;
_housePosProb = 0;
_roadPosProb = 0.9;
_otherPosProb = 0.1;
_renderRefreshPeriod = 5;
_renderMinRadius = 100;
_renderMaxRadius = 1000;
_dirtyDistance = 5;
_fn_initObj = {
    params ["_vehicle"];
    _vehicle setFuel random [0, 0, 1];
    _vehicle setVehicleAmmo random [0, 0.1, 1];
    _allParts = (getAllHitPointsDamage _vehicle) select 0;
    {
        _damage = random [0, 0.8, 0.9];
        _vehicle setHitPointDamage [_x, _damage];
    } forEach _allParts;
};

_logsEnabled = false;
_markersEnabled = false;
_markerType = "c_car";
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
