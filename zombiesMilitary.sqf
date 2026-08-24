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
_renderMaxRadius = 500;
_migrationRadius = 100;

_logsEnabled = false;
_markersEnabled = false;
_markerType = "o_hq";
_color = "Color3_FD_F";

private _fn_unitConstructor = {
	params ["_unit"];
    [_unit] spawn {
        params ["_unit"];
        _maxTime = 10;
        while {((magazines _unit) isEqualTo []) && (_maxTime > 0)} do {
            _maxTime = _maxTime - 1;
            sleep 1;
        };
        removeAllItemsWithMagazines _unit;
        removeAllAssignedItems _unit;
        removeAllWeapons _unit;
        removeBackpackGlobal _unit;
        removeUniform _unit;
        removeVest _unit;
        removeHeadgear _unit;
        removeGoggles _unit;
        _zombieLoadoutPrototypes = [
            "rhs_msv_emr_arifleman_rpk",
            "rhs_msv_emr_arifleman",
            "rhs_msv_emr_crew",
            "rhs_msv_emr_armoredcrew",
            "rhs_msv_emr_combatcrew",
            "rhs_msv_emr_crew_commander",
            "rhs_msv_emr_driver",
            "rhs_msv_emr_driver_armored",
            "rhs_msv_emr_efreitor",
            "rhs_msv_emr_engineer",
            "rhs_msv_emr_grenadier_rpg",
            "rhs_msv_emr_strelok_rpg_assist",
            "rhs_msv_emr_junior_sergeant",
            "rhs_msv_emr_machinegunner",
            "rhs_msv_emr_machinegunner_assistant",
            "rhs_msv_emr_marksman",
            "rhs_msv_emr_medic",
            "rhs_msv_emr_officer",
            "rhs_msv_emr_officer_armored",
            "rhs_msv_emr_rifleman",
            "rhs_msv_emr_grenadier",
            "rhs_msv_emr_LAT",
            "rhs_msv_emr_RShG2",
            "rhs_msv_emr_sergeant"
        ];
        _unit setUnitLoadout (selectRandom _zombieLoadoutPrototypes);
        _unit setVehicleAmmo random [0, 0.1, 1];
    };
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
