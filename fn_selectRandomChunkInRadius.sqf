params ["_chunks", "_pos", "_radius"];
scopeName "main";

_chunkColumn0 = _chunks select 0;
_chunk0_0 = _chunkColumn0 select 0;
_chunkNumberX = count _chunks;
_chunkNumberY = count _chunkColumn0;
_chunkSize = _chunk0_0 select 2;

_posX = _pos select 0;
_posY = _pos select 1;

_x0 = _posX - _radius;
_y0 = _posY - _radius;
_x1 = _posX + _radius;
_y1 = _posY + _radius;

_xi0 = (floor (_x0 / _chunkSize)) max 0;
_yi0 = (floor (_y0 / _chunkSize)) max 0;
_xi1 = (floor (_x1 / _chunkSize) + 1) min _chunkNumberX;
_yi1 = (floor (_y1 / _chunkSize) + 1) min _chunkNumberY;

_chunksSubset = [];
_weightSum = 0;
_cumulativeWeights = [];
for [{_x_ = _xi0}, {_x_ < _xi1}, {_x_ = _x_ + 1}] do {
	_chunksColumn = _chunks select _x_;
	_chunksSubsetColumn = [];
	for [{_y = _yi0}, {_y < _yi1}, {_y = _y + 1}] do {
		_chunk = _chunksColumn select _y;
		_chunksSubsetColumn pushBack _chunk;

		_chunkPos = _chunk select 0;
		_chunkScore = _chunk select 1;
		_chunkDist = _chunkPos distance2D _pos;
		_weight = 0;
		if (_chunkDist <= _radius) then {
			_weight = _chunkScore;
		};
		_weightSum = _weightSum + _chunkScore;
		_cumulativeWeights pushBack _weightSum;
	};
	_chunksSubset pushBack _chunksSubsetColumn;
};

([_chunksSubset, _cumulativeWeights] call fn_selectRandomChunk) breakOut "main";
