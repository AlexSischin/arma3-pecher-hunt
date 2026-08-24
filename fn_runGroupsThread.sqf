params [
	"_groupTypes",
	"_side",
	"_chunkSize",
	"_baseScoreBias",
	"_housesScoreYCoef",
	"_housesScoreXCoef",
	"_roadsScoreYCoef",
	"_roadsScoreXCoef",
	"_heightScoreYCoef",
	"_heightScoreXCoef",
	"_waterScoreBias",
	"_zones",
	"_groupsTotal",
	"_housePosProb",
	"_roadPosProb",
	"_otherPosProb",
	"_renderRefreshPeriod",
	"_renderMinRadius",
	"_renderMaxRadius",
	"_migrationRadius",
	"_logsEnabled",
	"_markersEnabled",
	"_markerType",
	"_color",
	"_fn_unitConstructor"
];
scopeName "main";

_name_prefix = [0, 999999] call BIS_fnc_randomInt;

_groupTypeWeights = [];
for [{_t = 0}, {_t < count _groupTypes}, {_t = _t + 1}] do {
	_type = _groupTypes select _t;
	_weight = _type select 1;
	_groupTypeWeights pushBack _weight;
};
_groupTypeCumulativeWeights = [_groupTypeWeights] call fn_buildCumulativeSums;

_chunks = [
	_chunkSize,
	_baseScoreBias,
	_housesScoreYCoef,
	_housesScoreXCoef,
	_roadsScoreYCoef,
	_roadsScoreXCoef,
	_heightScoreYCoef,
	_heightScoreXCoef,
	_waterScoreBias,
	_zones
] call fn_buildChunks;
_chunkCumulativeScores = [_chunks] call fn_buildChunkCumulativeScores;

if (_logsEnabled) then {
	_chunkXCount = count _chunks;
	_chunkYCount = 0;
	if (_chunkXCount > 0) then {
		_chunkYCount = count (_chunks select 0);
	};
	systemChat format ["Created chunks array %1x%2", _chunkXCount, _chunkYCount];
};

if (_markersEnabled) then {
	[_chunks, _color] call fn_visualizeChunks;
};

_groups = [];
for [{_g = 0}, {_g < _groupsTotal}, {_g = _g + 1}] do {
	_chunk = [_chunks, _chunkCumulativeScores] call fn_selectRandomChunk;
	_pos = [_chunk, _housePosProb, _roadPosProb, _otherPosProb] call fn_getRandomPos;
	_marker = "";
	if (_markersEnabled) then {
		_marker = createMarker [format ["group_%1_%2", _name_prefix, _g], _pos];
		_marker setMarkerType _markerType;
		_marker setMarkerColor _color;
	};

	_groupTypeId = [_groupTypeCumulativeWeights] call fn_selectRandomCumulativeWeightIndex;
	_groupType = _groupTypes select _groupTypeId;
	_unitClasses = _groupType select 0;
	_infantryUnitsMaxCount = _groupType select 2;
    _migrationProbability = _groupType select 3;
	_vehicleParamsArray = _groupType select 4;
	_vehiclesMaxCount = _groupType select 5;

	_infantryUnitsCount = 0;
	if (_infantryUnitsMaxCount > 0) then {
		_infantryUnitsCount = round (random [1, 1, _infantryUnitsMaxCount]);
	};
	_units = [];
	for [{_u = 0}, {_u < _infantryUnitsCount}, {_u = _u + 1}] do {
		_unitClass = selectRandom _unitClasses;
        _unitIsAlive = true;
        _unitUnit = objNull;
		_unit = [_unitClass, _unitIsAlive, _unitUnit];
        _units pushBack _unit;
	};

	_vehiclesCount = 0;
	if (_vehiclesMaxCount > 0) then {
		_vehiclesCount = round (random [1, 1, _vehiclesMaxCount]);
	};
	_vehicles = [];
	for [{_v = 0}, {_v < _vehiclesCount}, {_v = _v + 1}] do {
		_vehicleParams = selectRandom _vehicleParamsArray;
		_vehicleClass = _vehicleParams select 0;
		_vehicleCrewList =  _vehicleParams select 1;
		_vehicleUnits = [];
		for [{_c = 0}, {_c < count _vehicleCrewList}, {_c = _c + 1}] do {
			_vehicleCrew = _vehicleCrewList select _c;
			_vehicleCrewClass = _vehicleCrew select 0;
			_vehicleCrewRole = _vehicleCrew select 1;
			_vehicleCrewTurretPath = _vehicleCrew select 2;

			_unitIsAlive = true;
			_unitUnit = objNull;
			_unit = [_vehicleCrewClass, _unitIsAlive, _unitUnit];
			_unitId = count _units;
			_units pushBack _unit;

			_vehicleUnit = [_unitId, _vehicleCrewRole, _vehicleCrewTurretPath];
			_vehicleUnits pushBack _vehicleUnit;
		};
		_vehicleIsAlive = true;
		_vehicleVehicle = objNull;
		_vehicle = [_vehicleClass, _vehicleUnits, _vehicleIsAlive, _vehicleVehicle];
        _vehicles pushBack _vehicle;
	};

    _isRendered = false;
    _isKilled = false;
	_unitGroup = [_pos, _marker, _units, _migrationProbability, _isRendered, _isKilled, _vehicles];
	_groups pushBack _unitGroup;
};

if (_logsEnabled) then {
	systemChat format ["Created %1 groups", _groupsTotal];
	if (_groupsTotal > 0) then {
		systemChat format ["Group 0 is: %1", _groups select 0];
	};
};

while {true} do {
	sleep _renderRefreshPeriod;

	_renderSubjects = (units playerGroup) + ([] call fn_getControlledUavs);

	for [{_g = 0}, {_g < count _groups}, {_g = _g + 1}] do {
		_group = _groups select _g;
		_groupPos  = _group select 0;
		_groupMarker = _group select 1;
		_groupUnits  = _group select 2;
        _groupSpeed = _group select 3;
		_groupIsRendered = _group select 4;
		_groupIsKilled = _group select 5;
		_groupVehicles = _group select 6;

		_groupMigrationProbability = _groupSpeed * _renderRefreshPeriod / _migrationRadius;

		if (_logsEnabled) then {
			systemChat format ["[%1] Processing group: %2", _g, _group];
		};

		if (!_groupIsKilled) then {
			if (_groupIsRendered) then {
				scopeName "groupIsRendered";
				_groupGroup = objNull;
				_shouldBeRendered = false;
				for [{_u = 0}, {_u < count _groupUnits}, {_u = _u + 1}] do {
					_unit = _groupUnits select _u;
					_unitIsAlive =  _unit select 1;
					_unitUnit = _unit select 2;
					if (_unitIsAlive && !(isNull _unitUnit)) then {
						_unitUnitPos = getPos _unitUnit;
						_groupGroup = group _unitUnit;
						for [{_s = 0}, {_s < count _renderSubjects}, {_s = _s + 1}] do {
							_subject = _renderSubjects select _s;
							_subjectDistance = _subject distance2D _unitUnitPos;
							if (_subjectDistance < _renderMaxRadius) then {
								_shouldBeRendered = true;
								breakTo "groupIsRendered";
							};
						};
					};
				};

                if (!isNull _groupGroup) then {
                    _groupGroupLeader = leader _groupGroup;
                    _groupGroupLeaderPos = getPos _groupGroupLeader;
					_groupPos = [_groupGroupLeaderPos select 0, _groupGroupLeaderPos select 1];
					_group set [0, _groupPos];
					if (_markersEnabled) then {
                    	_groupMarker setMarkerPos _groupPos;
					};
                };

				if (_shouldBeRendered) then {
					if (_logsEnabled) then {
						systemChat format ["[%1] Group is rendered and should be rendered", _g];
					};
                    if ((_groupMigrationProbability > random 1) && (!isNull _groupGroup)) then {
                        _waypointChunk  = [_chunks, _groupPos , _migrationRadius] call fn_selectRandomChunkInRadius;
                        _waypointPos = [_waypointChunk, _housePosProb, _roadPosProb, _otherPosProb] call fn_getRandomPos;
                        for [{_u = 0}, {_u < count _groupUnits}, {_u = _u + 1}] do {
                            _unit = _groupUnits select _u;
                            _unitIsAlive =  _unit select 1;
                            _unitUnit = _unit select 2;
                            if (_unitIsAlive && !(isNull _unitUnit)) then {
                                _unitUnit doMove _waypointPos;
                            };
                        };
						if (_logsEnabled) then {
							systemChat format ["[%1] Set waypoint to %2", _g, _waypointPos];
						};
                    };
				} else {
					if (_logsEnabled) then {
						systemChat format ["[%1] Group is rendered but should not be rendered!", _g];
					};

                    for [{_v = 0}, {_v < count _groupVehicles}, {_v = _v + 1}] do {
                        _vehicle = _groupVehicles select _v;
                        _vehicleIsAlive = _vehicle select 2;
                        _vehicleVehicle = _vehicle select 3;
                        if (_vehicleIsAlive && !(isNull _vehicleVehicle)) then {
                            _vehicleCrewList = crew _vehicleVehicle;
                            _aliveVehicleCrewList = _vehicleCrewList select {alive _x};
                            if (0 == count _aliveVehicleCrewList) then {
                                _vehicleIsAlive = false;
                                _vehicle set [2, _vehicleIsAlive];
                            };
                            if (_vehicleIsAlive) then {
                                for [{_c = 0}, {_c < count _vehicleCrewList}, {_c = _c + 1}] do {
                                    _vehicleCrew = _vehicleCrewList select _c;
                                    moveOut _vehicleCrew;
                                };
                                deleteVehicle _vehicleVehicle;
                                if (_logsEnabled) then {
									systemChat format ["[%1] Deleted vehicle number %2", _g, _v];
								};
                            };
                            _vehicleVehicle = objNull;
                            _vehicle set [3, _vehicleVehicle];
                        };
                    };

					_hasAliveUnits = false;
					for [{_u = 0}, {_u < count _groupUnits}, {_u = _u + 1}] do {
						_unit = _groupUnits select _u;
						_unitIsAlive =  _unit select 1;
						_unitUnit = _unit select 2;
						if (_unitIsAlive && !(isNull _unitUnit)) then {
							_unitIsAlive = alive _unitUnit;
							_unit set [1, _unitIsAlive];
							if (_unitIsAlive) then {
								_hasAliveUnits = true;
								deleteVehicle _unitUnit;
								if (_logsEnabled) then {
									systemChat format ["[%1] Deleted unit number %2", _g, _u];
								};
							};
                            _unitUnit = objNull;
							_unit set [2, _unitUnit];
						};
					};
					if (!_hasAliveUnits) then {
						if (_markersEnabled) then {
							_groupMarker setMarkerColor "ColorGrey";
						};
						_groupIsKilled = true;
						_group set [5, _groupIsKilled];
						if (_logsEnabled) then {
							systemChat format ["[%1] All units are dead", _g];
						};
					};

					_groupIsRendered = false;
					_group set [4, _groupIsRendered];

				};
			} else {
				scopeName "groupIsNotRendered";
				_shouldBeRendered = false;
				for [{_s = 0}, {_s < count _renderSubjects}, {_s = _s + 1}] do {
					_subject = _renderSubjects select _s;
					_subjectDistance = _subject distance2D _groupPos;
					if (_subjectDistance < _renderMinRadius) then {
						_shouldBeRendered = false;
						breakTo "groupIsNotRendered";
					};
					if (_subjectDistance < _renderMaxRadius) then {
						_shouldBeRendered = true;
					};
				};

				if (_shouldBeRendered) then {
					if (_logsEnabled) then {
						systemChat format ["[%1] Group is not rendered but should be rendered!", _g];
					};
					_groupGroup = createGroup [_side, true];
					_placement = sqrt(count _groupUnits);
                    _waypointChunk  = [_chunks, _groupPos , _migrationRadius] call fn_selectRandomChunkInRadius;
                    _waypointPos = [_waypointChunk, _housePosProb, _roadPosProb, _otherPosProb] call fn_getRandomPos;
					for [{_u = 0}, {_u < count _groupUnits}, {_u = _u + 1}] do {
						_unit = _groupUnits select _u;
						_unitClass = _unit select 0;
						_unitIsAlive =  _unit select 1;
						_unitUnit = _unit select 2;
						if (_unitIsAlive && (isNull _unitUnit)) then {
							_unitUnit = _groupGroup createUnit [_unitClass, _groupPos, [], _placement, "NONE"];
							_unit set [2, _unitUnit];
                            _unitUnit setDir random 360;
                            _unitUnit doMove _waypointPos;
							if (_logsEnabled) then {
								systemChat format ["[%1] Created unit number %2", _g, _u];
							};
							if (!isNil "_fn_unitConstructor") then {
                            	[_unitUnit] call _fn_unitConstructor;
                            };
						};
					};

					if (0 < count _groupVehicles) then {
						_vehiclePos = _groupPos;
						_roadSearchRadius = _chunkSize * sqrt(2) / 2;
						_nearRoads = _groupPos nearRoads _roadSearchRadius;
						_nearestRoad = objNull;
						_nearestRoadDistance = _roadSearchRadius;
						for [{_r = 0}, {_r < count _nearRoads}, {_r = _r + 1}] do {
							_road = _nearRoads select _r;
							_roadPos = getPos _road;
							_roadDistance = _roadPos distance2D _groupPos;
							if (_roadDistance < _nearestRoadDistance) then {
								_nearestRoadDistance = _roadDistance;
								_nearestRoad = _road;
							};
						};
						if !(isNull _nearestRoad) then {
							_vehiclePos = getPos _nearestRoad;
						};
						for [{_v = 0}, {_v < count _groupVehicles}, {_v = _v + 1}] do {
							_vehicle = _groupVehicles select _v;
							_vehicleClass = _vehicle select 0;
							_vehicleUnits = _vehicle select 1;
							_vehicleIsAlive = _vehicle select 2;
							_vehicleVehicle = _vehicle select 3;
							if (_vehicleIsAlive && (isNull _vehicleVehicle)) then {
								_vehicleVehicle = createVehicle [_vehicleClass, _vehiclePos, [], _placement, "NONE"];
								_vehicle set [3, _vehicleVehicle];
								_vehicleDir = random 360;
								if !(isNull _nearestRoad) then {
									_nearestRoadDir = getDir _nearestRoad;
									_vehicleDir = _nearestRoadDir + (selectRandom [0, 180]);
								};
								_vehicleVehicle setDir _vehicleDir;
								for [{_u = 0}, {_u < count _vehicleUnits}, {_u = _u + 1}] do {
									_unit = _vehicleUnits select _u;
									_unitId = _unit select 0;
									_role = _unit select 1;
									_turretPath = _unit select 2;

									_unitUnit = _groupUnits select _unitId;
									_unitUnitIsAlive = _unitUnit select 1;
									_unitUnitUnit = _unitUnit select 2;
									if (_unitUnitIsAlive && !(isNull _unitUnitUnit)) then {
										switch (_role) do {
											case "driver": {
												_unitUnitUnit moveInDriver _vehicleVehicle;
											};
											case "gunner": {
												_unitUnitUnit moveInGunner _vehicleVehicle;
											};
											case "commander": {
												_unitUnitUnit moveInCommander _vehicleVehicle;
											};
											case "turret": {
												_unitUnitUnit moveInTurret [_vehicleVehicle, _turretPath];
											};
											default {
												_unitUnitUnit moveInAny _vehicleVehicle;
											};
										};
									};
								};
								if (_logsEnabled) then {
									systemChat format ["[%1] Created vehicle number %2", _g, _v];
								};
							};
						};
					};

					_groupIsRendered = true;
					_group set [4, _groupIsRendered];
				} else {
					if (_logsEnabled) then {
						systemChat format ["[%1] Group is not rendered and should not be rendered", _g];
					};
					if (_groupMigrationProbability > random 1) then {
                        _groupChunk  = [_chunks, _groupPos , _migrationRadius] call fn_selectRandomChunkInRadius;
                        _groupPos = [_groupChunk, _housePosProb, _roadPosProb, _otherPosProb] call fn_getRandomPos;
                        _group set [0, _groupPos];
						if (_markersEnabled) then {
                        	_groupMarker setMarkerPos _groupPos;
						};
						if (_logsEnabled) then {
							systemChat format ["[%1] Migrated to %2", _g, _groupPos];
						};
                    };
				};
			};
		};
	};
};
