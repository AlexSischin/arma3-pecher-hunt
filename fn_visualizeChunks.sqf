params ["_chunks", "_color"];
scopeName "main";

_name_prefix = [0, 999999] call BIS_fnc_randomInt;

_maxChunkScore = 0;
for [{_x_ = 0}, {_x_ < count _chunks}, {_x_ = _x_ + 1}] do {
	_chunksColumn = _chunks select _x_;
    for [{_y = 0}, {_y < count _chunksColumn}, {_y = _y + 1}] do {
		_chunk = _chunksColumn select _y;
		_chunkScore = _chunk select 1;
		_maxChunkScore = _maxChunkScore max _chunkScore;
	};
};

for [{_x_ = 0}, {_x_ < count _chunks}, {_x_ = _x_ + 1}] do {
	_chunksColumn = _chunks select _x_;
    for [{_y = 0}, {_y < count _chunksColumn}, {_y = _y + 1}] do {
		_chunk = _chunksColumn select _y;
		_chunkPos = _chunk select 0;
		_chunkScore = _chunk select 1;
		_chunkSize = _chunk select 2;
		_markerName = format ["chunk_%1_%2_%3", _name_prefix, _x_, _y];
		_marker = createMarker [_markerName, _chunkPos];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkerSize [_chunkSize / 2, _chunkSize / 2];
		_marker setMarkerBrush "SOLID";
		_marker setMarkerColor _color;
		_marker setMarkerAlpha (_chunkScore / _maxChunkScore);
	};
};
