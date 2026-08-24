_groupTypes = [
//	[[
//		"Zombie_G_Crawler_NATO",
//		"Zombie_G_Walker_NATO"
//	], 1, 32, 0.5, [], 0],
	[[
		"Zombie_G_Shooter_NATO"
	], 2, 16, 0.5, [], 0],
	[[
		"Zombie_G_Shambler_NATO",
		"Zombie_G_RA_NATO",
		"Zombie_G_RC_NATO"
	], 1, 16, 8, [], 0]
];
_side = independent;
_chunkSize = 100;
_baseScoreBias = 0.001;
_housesScoreYCoef = 0.5;
_housesScoreXCoef = 0.02;
_roadsScoreYCoef = 0.001;
_roadsScoreXCoef = 1;
_heightScoreYCoef = -0.005;
_heightScoreXCoef = 0.002;
_waterScoreBias = -1;
_safeZoneBias = -1;
_dangerZoneBias = 0.01;
_militaryZoneBias = 0.1;
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
_groupsTotal = 100;
_housePosProb = 0.5;
_roadPosProb = 0.1;
_otherPosProb = 0.4;
_renderRefreshPeriod = 5;
_renderMinRadius = 100;
_renderMaxRadius = 250;
_migrationRadius = 100;

_logsEnabled = false;
_markersEnabled = false;
_markerType = "o_hq";
_color = "Color3_FD_F";

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
