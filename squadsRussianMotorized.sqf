_groupTypes = [
	[[
        "rhs_msv_emr_arifleman_rpk",
        "rhs_msv_emr_arifleman",
        "rhs_msv_emr_efreitor",
        "rhs_msv_emr_engineer",
        "rhs_msv_emr_grenadier_rpg",
        "rhs_msv_emr_junior_sergeant",
        "rhs_msv_emr_machinegunner",
        "rhs_msv_emr_marksman",
        "rhs_msv_emr_medic",
        "rhs_msv_emr_officer",
        "rhs_msv_emr_officer_armored",
        "rhs_msv_emr_rifleman",
        "rhs_msv_emr_grenadier",
        "rhs_msv_emr_LAT",
        "rhs_msv_emr_RShG2",
        "rhs_msv_emr_sergeant"
	], 1, 10, 10, [
		["rhs_bmd4ma_vdv", [["rhs_msv_emr_combatcrew", "driver", []], ["rhs_msv_emr_combatcrew", "gunner", [0]], ["rhs_msv_emr_combatcrew", "turret", [0, 0]], ["rhs_msv_emr_combatcrew", "turret", [1]], ["rhs_msv_emr_combatcrew", "turret", [2]]]],
		["rhs_bmp3mera_msv", [["rhs_msv_emr_combatcrew", "driver", []], ["rhs_msv_emr_combatcrew", "gunner", [0]], ["rhs_msv_emr_combatcrew", "commander", [0, 0]], ["rhs_msv_emr_combatcrew", "turret", [1]], ["rhs_msv_emr_combatcrew", "turret", [2]]]]
	], 1]
];
_side = east;
_chunkSize = 100;
_baseScoreBias = 0.001;
_housesScoreYCoef = -5;
_housesScoreXCoef = 1;
_roadsScoreYCoef = 1;
_roadsScoreXCoef = 5;
_heightScoreYCoef = 0.01;
_heightScoreXCoef = 0.002;
_waterScoreBias = -1;
_safeZoneBias = -1;
_dangerZoneBias = -3;
_militaryZoneBias = 0.01;
_safeZones = [
	["base_zone", _safeZoneBias]
];
_dangerZones = [
	["danger_zone_0", _dangerZoneBias]
];
_militaryZones = [
	["military_zone_0", _militaryZoneBias],
	["military_zone_1", _militaryZoneBias],
	["military_zone_2", _militaryZoneBias],
	["military_zone_3", _militaryZoneBias],
	["military_zone_4", _militaryZoneBias]
];

_allZones = _safeZones + _dangerZones + _militaryZones;
_groupsTotal = 1;
_housePosProb = 0;
_roadPosProb = 1;
_otherPosProb = 0;
_renderRefreshPeriod = 5;
_renderMinRadius = 500;
_renderMaxRadius = 3000;
_migrationRadius = 500;

_logsEnabled = false;
_markersEnabled = false;
_markerType = "b_motor_inf";
_color = "ColorEAST";

[
    _groupTypes,
	_side,
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
    _groupsTotal,
    _housePosProb,
    _roadPosProb,
    _otherPosProb,
    _renderRefreshPeriod,
    _renderMinRadius,
    _renderMaxRadius,
    _migrationRadius,
    _logsEnabled,
    _markersEnabled,
    _markerType,
    _color,
    nil
] spawn fn_runGroupsThread;
