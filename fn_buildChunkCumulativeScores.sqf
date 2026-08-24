params ["_chunks"];
scopeName "main";

_sum = 0;
_scores = [];
for [{_x_ = 0}, {_x_ < count _chunks}, {_x_ = _x_ + 1}] do {
	_chunksColumn = _chunks select _x_;
    for [{_y = 0}, {_y < count _chunksColumn}, {_y = _y + 1}] do {
		_chunk = _chunksColumn select _y;
		_score = _chunk select 1;
		_sum = _sum + _score;
		_scores pushBack _sum;
	};
};
_scores breakOut "main";
