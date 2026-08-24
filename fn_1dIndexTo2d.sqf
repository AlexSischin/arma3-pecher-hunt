params ["_1dIndex", "_2dArray"];
scopeName "main";

_minorAxisSize = count (_2dArray select 0);

[floor (_1dIndex / _minorAxisSize), _1dIndex % _minorAxisSize];
