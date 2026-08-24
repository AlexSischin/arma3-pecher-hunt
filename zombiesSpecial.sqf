_groupTypes = [
	[[
		"Zombie_Special_GREENFOR_Boomer"
	], 1, 5, 7, [], 0],
	[[
		"WBK_SpecialZombie_Corrupted_1"
	], 1, 20, 1, [], 0],
//	[[
//		"WBK_Goliaph_2"
//	], 0.05, 1, 10, [], 0],
	[[
		"Zombie_Special_GREENFOR_Leaper_1",
		"Zombie_Special_GREENFOR_Leaper_2"
	], 1, 3, 8, [], 0]
//	[[
//		"Zombie_Special_GREENFOR_Screamer"
//	], 1, 5, 2, [], 0]
//	[[
//		"WBK_SpecialZombie_Smasher_1",
//		"WBK_SpecialZombie_Smasher_Hellbeast_1",
//		"WBK_SpecialZombie_Smasher_Acid_1"
//	], 0.2, 1, 9, [], 0]
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
_housePosProb = 0.3;
_roadPosProb = 0.1;
_otherPosProb = 0.6;
_renderRefreshPeriod = 5;
_renderMinRadius = 100;
_renderMaxRadius = 1000;
_migrationRadius = 100;

_logsEnabled = false;
_markersEnabled = false;
_markerType = "o_armor";
_color = "Color1_FD_F";

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
