params ["_chunk", "_housePosProb", "_roadPosProb", "_otherPosProb"];
scopeName "main";

_chunkPos = _chunk select 0;
_chunkSize = _chunk select 2;
_posTypeCumulativeChances = [[_housePosProb, _roadPosProb, _otherPosProb]] call fn_buildCumulativeSums;
_posTypeindex = [_posTypeCumulativeChances] call fn_selectRandomCumulativeWeightIndex;
_chunkCcr = _chunkSize * sqrt(2) / 2;

_pos = [];
if (_posTypeindex == 0) then {
	_nearHouses = nearestObjects [_chunkPos, ["house"], _chunkCcr, true];
	if (count _nearHouses > 0) then {
		_nearHouse = selectRandom _nearHouses;
		_nearHousePositions = [_nearHouse] call BIS_fnc_buildingPositions;
		if (count _nearHousePositions > 0) then {
			(selectRandom _nearHousePositions) breakOut "main";
		};
	};
};
if (_posTypeindex == 1) then {
	_nearRoads = _chunkPos nearRoads _chunkCcr;
	if (count _nearRoads > 0) then {
		_nearRoad = selectRandom _nearRoads;
		(getPos _nearRoad) breakOut "main";
	};
};
(_chunkPos vectorAdd [random _chunkSize - _chunkSize / 2, random _chunkSize - _chunkSize / 2]) breakOut "main";
