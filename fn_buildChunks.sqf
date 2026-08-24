params ["_chunkSize", "_baseScoreBias", "_housesScoreYCoef", "_housesScoreXCoef", "_roadsScoreYCoef", "_roadsScoreXCoef", "_heightScoreYCoef", "_heightScoreXCoef", "_waterScoreBias", "_markersAndBiases"];
scopeName "main";

_houseMaxDistance = 500;
_roadMaxDistance = 200;
_chunksAxisNumber = ceil (worldSize / _chunkSize);
_totalScoreYCoef = 1;
_totalScoreXCoef = (0 max _housesScoreYCoef) + (0 max _roadsScoreYCoef);
if (_totalScoreXCoef == 0) then {
	_totalScoreXCoef = exp(1);
} else {
	_totalScoreXCoef = exp(1) / _totalScoreXCoef;
};
_chunks = [];
for [{_x_ = 0}, {_x_ < _chunksAxisNumber}, {_x_ = _x_ + 1}] do {
	_chunksColumn = [];
    for [{_y = 0}, {_y < _chunksAxisNumber}, {_y = _y + 1}] do {
        _center = [(_x_ + 0.5) * _chunkSize, (_y + 0.5) * _chunkSize];
		_score = 0;

		_housesScore = 0;
        _nearHouses = nearestObjects [_center, ["house"], _houseMaxDistance, true];
		for [{_h = 0}, {_h < count _nearHouses}, {_h = _h + 1}] do {
			_house = _nearHouses select _h;
			_houseDistance = _house distance2D _center;
			_housesScore = _housesScore + 1 / _houseDistance;
		};
		_housesScore = [_housesScore, _housesScoreYCoef, _housesScoreXCoef] call fn_sigmaScore;

		_roadsScore = 0;
        _nearRoads = _center nearRoads _roadMaxDistance;
		for [{_r = 0}, {_r < count _nearRoads}, {_r = _r + 1}] do {
			_road = _nearRoads select _r;
			_roadDistance = _road distance2D _center;
			_roadsScore = _roadsScore + 1 / _roadDistance;
		};
		_roadsScore = [_roadsScore, _roadsScoreYCoef, _roadsScoreXCoef] call fn_sigmaScore;

		_heightScore = getTerrainHeightASL _center;
		_heightScore = [_heightScore, _heightScoreYCoef, _heightScoreXCoef] call fn_sigmaScore;

		_waterScore = 0;
		if (surfaceIsWater _center) then {
			_waterScore = _waterScoreBias;
		};

		_markerScore = 0;
		for [{_m = 0}, {_m < count _markersAndBiases}, {_m = _m + 1}] do {
			_markerAndBias = _markersAndBiases select _m;
			_marker = _markerAndBias select 0;
			_bias = _markerAndBias select 1;
			if (_center inArea _marker) then {
				_markerScore = _bias;
			};
		};

		_score = _baseScoreBias + _housesScore + _roadsScore + _heightScore + _waterScore + _markerScore;
		_score = [_score, _totalScoreYCoef, _totalScoreXCoef] call fn_sigmaScore;
		_score = 0 max _score;

        _chunksColumn pushBack [_center, _score, _chunkSize];
    };
	_chunks pushBack _chunksColumn;
};
_chunks;
