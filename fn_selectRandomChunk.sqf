params ["_chunks", "_chunkCumulativeScores"];
scopeName "main";

_chunkIndex1d = [_chunkCumulativeScores] call fn_selectRandomCumulativeWeightIndex;
_chunkIndex2d = [_chunkIndex1d, _chunks] call fn_1dIndexTo2d;
_x_ = _chunkIndex2d select 0;
_y = _chunkIndex2d select 1;
((_chunks select _x_) select _y) breakOut "main";
