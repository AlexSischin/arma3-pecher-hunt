scopeName "main";

_allUavs = allUnitsUAV;
_controlledUavs = [];
for [{_u = 0}, {_u < count _allUavs}, {_u = _u + 1}] do {
	_uav = _allUavs select _u;
	_uavControl = UAVControl _uav;
	_uavControlCount = floor((count _uavControl) / 2);
	for [{_c = 0}, {_c < _uavControlCount}, {_c = _c + 1}] do {
		_uavControlUnit = _uavControl select (_c * 2);
		if !(isNull _uavControlUnit) then {
			_controlledUavs pushBack _uav;
			break;
		};
	};
};
_controlledUavs;
