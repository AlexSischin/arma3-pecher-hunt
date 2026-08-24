params ["_arr"];
scopeName "main";

_sum = 0;
_cumulativeSums = [];
for [{_i = 0}, {_i < count _arr}, {_i = _i + 1}] do {
	_e = _arr select _i;
	_sum = _sum + _e;
	_cumulativeSums pushBack _sum;
};
_cumulativeSums;
