_groupTypes = [
	[[
		"WBK_SpecialZombie_Smasher_Hellbeast_1"
	], 1, 1, 10, [], 0]
];
_side = independent;
_chunkSize = 100;
_baseScoreBias = 0.0005;
_housesScoreYCoef = 1;
_housesScoreXCoef = 0.005;
_roadsScoreYCoef = 0.001;
_roadsScoreXCoef = 1;
_heightScoreYCoef = -0.005;
_heightScoreXCoef = 0.002;
_waterScoreBias = -1;
_safeZoneBias = -1;
_dangerZoneBias = 0.003;
_militaryZoneBias = 0;
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
_housePosProb = 0.3;
_roadPosProb = 0.1;
_otherPosProb = 0.6;
_renderRefreshPeriod = 5;
_renderMinRadius = 0;
_renderMaxRadius = 10000;
_migrationRadius = 100;

_logsEnabled = false;
_markersEnabled = false;
_markerType = "MinefieldAP";
_color = "ColorRed";

private _fn_unitConstructor = {
	params ["_unit"];
    mrBeast = _unit;
};

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
    _fn_unitConstructor
] spawn fn_runGroupsThread;
