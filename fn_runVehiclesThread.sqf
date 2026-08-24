params [
	"_vehicleTypes",
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
	"_vehiclesTotal",
	"_housePosProb",
	"_roadPosProb",
	"_otherPosProb",
	"_renderRefreshPeriod",
	"_renderMinRadius",
	"_renderMaxRadius",
	"_dirtyDistance",
	"_fn_initObj",
	"_logsEnabled",
	"_markersEnabled",
	"_markerType",
	"_color"
];
scopeName "main";

_name_prefix = [0, 999999] call BIS_fnc_randomInt;

_vehicleTypeWeights = [];
for [{_t = 0}, {_t < count _vehicleTypes}, {_t = _t + 1}] do {
	_type = _vehicleTypes select _t;
	_weight = _type select 1;
	_vehicleTypeWeights pushBack _weight;
};
_vehicleTypeCumulativeWeights = [_vehicleTypeWeights] call fn_buildCumulativeSums;

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

_vehicles = [];
for [{_v = 0}, {_v < _vehiclesTotal}, {_v = _v + 1}] do {
	_chunk = [_chunks, _chunkCumulativeScores] call fn_selectRandomChunk;
	_pos = [_chunk, _housePosProb, _roadPosProb, _otherPosProb] call fn_getRandomPos;
	_marker = "";
	if (_markersEnabled) then {
		_marker = createMarker [format ["vehicle_%1_%2", _name_prefix, _v], _pos];
		_marker setMarkerType _markerType;
		_marker setMarkerColor _color;
	};

	_vehicleTypeId = [_vehicleTypeCumulativeWeights] call fn_selectRandomCumulativeWeightIndex;
	_vehicleType = _vehicleTypes select _vehicleTypeId;
	_vehicleClasses = _vehicleType select 0;

	_class = selectRandom _vehicleClasses;
	_internalState = [];
	_dir = random 360;
	_roadSearchRadius = _chunkSize * sqrt(2) / 2;
	_nearRoads = _pos nearRoads _roadSearchRadius;
	_nearestRoad = objNull;
	_nearestRoadDistance = _roadSearchRadius;
	for [{_r = 0}, {_r < count _nearRoads}, {_r = _r + 1}] do {
		_road = _nearRoads select _r;
		_roadPos = getPos _road;
		_roadDistance = _roadPos distance2D _pos;
		if (_roadDistance < _nearestRoadDistance) then {
			_nearestRoadDistance = _roadDistance;
			_nearestRoad = _road;
		};
	};
	if !(isNull _nearestRoad) then {
		_dir = getDir _nearestRoad + selectRandom [0, 180];
	};
	_obj = objNull;
    _isRendered = false;
    _isKilled = false;
	_isDirty = false;
	_isInitiated = false;
	_vehicle = [_pos, _marker, _class, _internalState, _dir, _obj, _isRendered, _isKilled, _isDirty, _isInitiated];
	_vehicles pushBack _vehicle;
};

if (_logsEnabled) then {
	systemChat format ["Created %1 vehicles", _vehiclesTotal];
	if (_vehiclesTotal > 0) then {
		systemChat format ["Vehicle 0 is: %1", _vehicles select 0];
	};
};

while {true} do {
	sleep _renderRefreshPeriod;

	_renderSubjects = (units playerGroup) + ([] call fn_getControlledUavs);

	for [{_v = 0}, {_v < count _vehicles}, {_v = _v + 1}] do {
		_vehicle = _vehicles select _v;
		_pos  = _vehicle select 0;
		_marker = _vehicle select 1;
		_class = _vehicle select 2;
		_internalState = _vehicle select 3;
		_dir = _vehicle select 4;
		_obj = _vehicle select 5;
		_isRendered = _vehicle select 6;
		_isKilled = _vehicle select 7;
		_isDirty = _vehicle select 8;
		_isInitiated = _vehicle select 9;

		if (_logsEnabled) then {
			systemChat format ["[%1] Processing vehicle: %2", _v, _vehicle];
		};

		if (!_isKilled && !_isDirty) then {
			if (_isRendered) then {
				scopeName "isRendered";
				_shouldBeRendered = false;
				for [{_s = 0}, {_s < count _renderSubjects}, {_s = _s + 1}] do {
					_subject = _renderSubjects select _s;
					_subjectDistance = _subject distance2D _pos;
					if (_subjectDistance < _renderMaxRadius) then {
						_shouldBeRendered = true;
						breakTo "isRendered";
					};
				};

				_objPos = getPos _obj;
				_pos = [_objPos select 0, _objPos select 1];
				_vehicle set [0, _pos];
				if (_markersEnabled) then {
					_marker setMarkerPos _pos;
				};
				_internalState = [_obj] call fn_getVehicleInternalState;
				_vehicle set [3, _internalState];
				_dir = getDir _obj;
				_vehicle set [4, _dir];
				_isKilled = !alive _obj;
				_vehicle set [7, _isKilled];
				_isDirty = false;
				for [{_s = 0}, {_s < count _renderSubjects}, {_s = _s + 1}] do {
					_subject = _renderSubjects select _s;
					_subjectDistance = _subject distance2D _pos;
					if (_subjectDistance < _dirtyDistance) then {
						_isDirty = true;
						breakTo "isRendered";
					};
				};
				_vehicle set [8, _isDirty];

				if (_isKilled) then {
					if (_markersEnabled) then {
						_marker setMarkerColor "ColorGrey";
					};
					if (_logsEnabled) then {
						systemChat format ["[%1] Vehicle is destroyed", _v];
					};
				} else {
					if (_isDirty) then {
						if (_markersEnabled) then {
							_marker setMarkerColor "ColorGrey";
						};
						if (_logsEnabled) then {
							systemChat format ["[%1] Vehicle is dirty", _v];
						};
					} else {
						if (_shouldBeRendered) then {
							if (_logsEnabled) then {
								systemChat format ["[%1] Vehicle is rendered and should be rendered", _v];
							};
						} else {
							if (_logsEnabled) then {
								systemChat format ["[%1] Vehicle is rendered but should not be rendered!", _v];
							};

							_crewList = crew _obj;
							for [{_c = 0}, {_c < count _crewList}, {_c = _c + 1}] do {
								_crew = _crewList select _c;
								moveOut _crew;
							};
							deleteVehicle _obj;
							if (_logsEnabled) then {
								systemChat format ["[%1] Deleted vehicle", _v];
							};

							_obj = objNull;
							_vehicle set [5, _obj];

							_isRendered = false;
							_vehicle set [6, _isRendered];
						};
					};
				};
			} else {
				scopeName "isNotRendered";
				_shouldBeRendered = false;
				for [{_s = 0}, {_s < count _renderSubjects}, {_s = _s + 1}] do {
					_subject = _renderSubjects select _s;
					_subjectDistance = _subject distance2D _pos;
					if (_subjectDistance < _renderMinRadius) then {
						_shouldBeRendered = false;
						breakTo "isNotRendered";
					};
					if (_subjectDistance < _renderMaxRadius) then {
						_shouldBeRendered = true;
					};
				};

				if (_shouldBeRendered) then {
					if (_logsEnabled) then {
						systemChat format ["[%1] Vehicle is not rendered but should be rendered!", _v];
					};

					_obj = createVehicle [_class, _pos, [], 0, "NONE"];
					_vehicle set [5, _obj];
					if (_isInitiated) then {
						[_obj, _internalState] call fn_setVehicleInternalState;
					} else {
						[_obj] call _fn_initObj;
					};
					_obj setDir _dir;

					_isRendered = true;
					_vehicle set [6, _isRendered];
				} else {
					if (_logsEnabled) then {
						systemChat format ["[%1] Vehicle is not rendered and should not be rendered", _v];
					};
				};
			};
		};
	};
};
