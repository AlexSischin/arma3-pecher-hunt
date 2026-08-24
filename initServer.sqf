setTimeMultiplier 24;

fn_sigmaScore = compile preprocessFile "fn_sigmaScore.sqf";
fn_buildChunks = compile preprocessFile "fn_buildChunks.sqf";
fn_visualizeChunks = compile preprocessFile "fn_visualizeChunks.sqf";
fn_buildChunkCumulativeScores = compile preprocessFile "fn_buildChunkCumulativeScores.sqf";
fn_selectRandomChunk = compile preprocessFile "fn_selectRandomChunk.sqf";
fn_selectRandomCumulativeWeightIndex = compile preprocessFile "fn_selectRandomCumulativeWeightIndex.sqf";
fn_1dIndexTo2d = compile preprocessFile "fn_1dIndexTo2d.sqf";
fn_buildCumulativeSums = compile preprocessFile "fn_buildCumulativeSums.sqf";
fn_getRandomPos = compile preprocessFile "fn_getRandomPos.sqf";
fn_selectRandomChunkInRadius = compile preprocessFile "fn_selectRandomChunkInRadius.sqf";
fn_runGroupsThread = compile preprocessFile "fn_runGroupsThread.sqf";
fn_getControlledUavs = compile preprocessFile "fn_getControlledUavs.sqf";
fn_getVehicleInternalState = compile preprocessFile "fn_getVehicleInternalState.sqf";
fn_setVehicleInternalState = compile preprocessFile "fn_setVehicleInternalState.sqf";
fn_runVehiclesThread = compile preprocessFile "fn_runVehiclesThread.sqf";

execVM "zombiesCivilian.sqf";
execVM "zombiesMilitary.sqf";
execVM "zombiesSpecial.sqf";
execVM "squadsRussianMotorized.sqf";
execVM "emptyCars.sqf";
execVM "specialUnit.sqf";
execVM "missionScript.sqf";
