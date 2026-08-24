params ["_cumulativeWeights"];
scopeName "main";

_totalSum = _cumulativeWeights select -1;
_r = random _totalSum;
_low = 0;
_high = count _cumulativeWeights - 1;
while {_low < _high} do {
    _mid = floor ((_low + _high) / 2);
    _midVal = _cumulativeWeights select _mid;

    if (_r < _midVal) then {
        _high = _mid;
    } else {
        _low = _mid + 1;
    };
};

_low breakOut "main";
