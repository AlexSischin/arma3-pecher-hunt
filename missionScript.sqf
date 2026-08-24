playerGroupCommander = leader playerGroup;
playerGroupUnits = units playerGroup;

// Alpha12 task
[] spawn {
    // Init
    [
        playerGroup,
        "findAlpha12",
        [
            "Alpha 1-2 has been shot down in Pecher and we have lost contact with the crew. " +
                "Locate the downed helicopter and determine whether any of the crew are still alive. " +
                "Recover them if possible. Finish before it gets dark!",
            "Locate Alpha 1-2 before 18:00"
        ],
        "alpha_1_2",
        "ASSIGNED",
        100,
        true
    ] call BIS_fnc_taskCreate;

    // Timer
    [] spawn {
        while {daytime < 18} do {sleep 1};
        if ("findAlpha12" call BIS_fnc_taskState != "SUCCEEDED") then {
            ["alpha12NotFound", false, 2] remoteExec ["BIS_fnc_endMission", 0, true];
        }
    };

    // Wait until Alpha 1-2 is found
    while {{_x distance alpha12heli < 10} count playerGroupUnits == 0} do {sleep 1};

    ["findAlpha12", "SUCCEEDED", true] call BIS_fnc_taskSetState;
    playerGroupCommander sideChat "HQ, this is Alpha 1-1. We have located Alpha 1-2. No survivors. Do you copy?";
    sleep 3;
    [west, "HQ"] sideChat "Copy, Alpha 1-1. Continue with the main objective.";
    sleep 10;

    // Main task
    [] spawn {
        // Init
        [
            playerGroup,
            "killMrBeast",
            [
                "Locate and eliminate the unidentified biological reported by Alpha 1-2. Confirm that the target is dead before proceeding to extraction.",
                "Eliminate the hostile"
            ],
            objNull,
            "ASSIGNED",
            80,
            true
        ] call BIS_fnc_taskCreate;
        // Wait until the target has spawned
        while {isNil "mrBeast"} do {sleep 1};

        // Wait until the target is dead
        while {alive mrBeast} do {sleep 0.1};

        mrBeastBlood = "BloodPool_01_Large_New_F" createVehicle (getPos mrBeast);
        // Wait until target is confirmed dead
        while {{_x distance mrBeastBlood < 5} count playerGroupUnits == 0} do {sleep 1};

        ["killMrBeast", "SUCCEEDED", true] call BIS_fnc_taskSetState;
        _closestUnits = [playerGroupUnits, [], {mrBeastBlood distance _x}, "ASCEND"] call BIS_fnc_sortBy;
        _closestUnit = _closestUnits select 0;
        _closestUnit groupChat "What the fuck?! This asshole just disappeared!";
        sleep 5;
        playerGroupCommander sideChat "This is Alpha 1-1. The unidentified biological has been eliminated. " +
            "Repeat, the targed is eliminated. The corpse disintegrated immediately afterwards, only blood has left. " +
            "This is a headache for scientists and other eggheads. Alpha 1-1 is proceeding to the extraction point.";
        [
            playerGroup,
            "moveToExtractionPoint",
            [
                "Return to the extraction point and exfiltrate.",
                "Exfiltrate"
            ],
            getMarkerPos "base_zone",
            "ASSIGNED",
            1,
            true
        ] call BIS_fnc_taskCreate;
        // Wait until the team returned to extraction point
        while {({_x inArea "base_zone"} count playerGroupUnits) != ({alive _x} count playerGroupUnits)} do {sleep 1};

        ["moveToExtractionPoint", "SUCCEEDED", true] call BIS_fnc_taskSetState;
        playerGroupCommander sideChat "Reporting: mission completed.";
        ["success", true, true] remoteExec ["BIS_fnc_endMission", 0, true];
    };

    // Ammo vehicle task
    [] spawn {
        // Init
        _center = getMarkerPos "ammoVehicleArea";
        _radius = (getMarkerSize "ammoVehicleArea") select 0;
        _roads = _center nearRoads _radius;
        _road = selectRandom _roads;
        ammoVehicle setPos getPos _road;
        ammoVehicle setDir ((getDir _road) + (selectRandom [0, 180]));
        ammoVehicle setHitPointDamage ["hitfuel", 1.0];
        ammoVehicle setHitPointDamage ["hitlfwheel", 1.0];
        ammoVehicle setHitPointDamage ["hitrfwheel", 1.0];
        ammoVehicle setHitPointDamage ["hitlf2wheel", 1.0];
        ammoVehicle setHitPointDamage ["hitrf2wheel", 1.0];
        ammoVehicle setHitPointDamage ["hitlmwheel", 1.0];
        ammoVehicle setHitPointDamage ["hitrmwheel", 1.0];
        ammoVehicle setHitPointDamage ["hitlbwheel", 1.0];
        ammoVehicle setHitPointDamage ["hitrbwheel", 1.0];
        [
            playerGroup,
            "lootAmmoVehicle",
            [
                "Bravo Company lost contact with a ground convoy carrying TOW launchers for Alpha. " +
                    "Alpha 1-2 reported that the driver was killed, but the vehicle and its cargo may still be intact. " +
                    "Locate the truck and recover the launchers if possible.",
                "Recover the TOW launchers"
            ],
            "ammoVehicleArea",
            "CREATED",
            50,
            true
        ] call BIS_fnc_taskCreate;
        // Wait until dhe ammo vehicle is found
        while {{_x distance ammoVehicle < 3} count playerGroupUnits == 0} do {sleep 1};

        ["lootAmmoVehicle", "SUCCEEDED", true] call BIS_fnc_taskSetState;
        _closestUnits = [playerGroupUnits, [], {ammoVehicle distance _x}, "ASCEND"] call BIS_fnc_sortBy;
        _closestUnit = _closestUnits select 0;
        _closestUnit groupChat "I found the truck. The driver's missing, but the TOWs are still here.";
        sleep 5;
        playerGroupCommander sideChat "This is Alpha 1-1. We've located the Bravo Company truck. " +
            "The driver is missing, but the TOW launchers are intact. Continuing the operation.";
    };

    // Ammo box task
    [] spawn {
        // Init
        [
            playerGroup,
            "lootAmmoBox",
            [
                "Russian forces abandoned a shipment of ammunition at the military base several days ago. " +
                    "Recover it if it is still intact.",
                "Recover the ammunition"
            ],
            ammoBox,
            "CREATED",
            30,
            true
        ] call BIS_fnc_taskCreate;
        // Wait until the ammo box is found
        while {{_x distance ammoBox < 3} count playerGroupUnits == 0} do {sleep 1};

        ["lootAmmoBox", "SUCCEEDED", true] call BIS_fnc_taskSetState;
        _closestUnits = [playerGroupUnits, [], {ammoBox distance _x}, "ASCEND"] call BIS_fnc_sortBy;
        _closestUnit = _closestUnits select 0;
        _closestUnit groupChat "I found the Russian ammunition.";
        sleep 5;
        playerGroupCommander sideChat "This is Alpha 1-1. We've recovered the Russian ammunition.";
    };
};
