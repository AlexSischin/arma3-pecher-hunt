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
    while {{_x distance alpha12heli < 20} count playerGroupUnits == 0} do {sleep 1};

    [playerGroupCommander, "HQ, this is Alpha 1-1. We have located the Alpha 1-2 crash site. No survivors. I say again, no survivors. Do you copy?"]
        remoteExec ["commandChat", 0];
    ["findAlpha12", "SUCCEEDED", true] call BIS_fnc_taskSetState;
    sleep 10;
    [[west, "HQ"], "Copy, Alpha 1-1. Phase One is complete. Proceed to Phase Two. Locate and eliminate the unidentified biological. HQ out."]
        remoteExec ["commandChat", 0];

    // Main task
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
    [] spawn {
        // Wait until the target has spawned
        while {isNil "mrBeast"} do {sleep 1};

        // Wait until the target is dead
        while {alive mrBeast} do {sleep 0.1};

        mrBeastBlood = "BloodPool_01_Large_New_F" createVehicle (getPos mrBeast);
        ["killMrBeast", getPos mrBeastBlood] call BIS_fnc_taskSetDestination;
        // Wait until target is confirmed dead
        while {{_x distance mrBeastBlood < 10} count playerGroupUnits == 0} do {sleep 1};

        ["killMrBeast", "SUCCEEDED", true] call BIS_fnc_taskSetState;
        [playerGroupCommander, "This is Alpha 1-1. The unidentified biological has been eliminated. " +
            "Repeat, the target is eliminated. The corpse disintegrated; only blood remains. How copy?"]
            remoteExec ["commandChat", 0];
        sleep 5;
        [[west, "HQ"], "Copy, Alpha 1-1. Phase Two is complete. Proceed to exfiltration. HQ out."]
            remoteExec ["commandChat", 0];
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
        [playerGroupCommander, "Folks, we fucking did it!"]
            remoteExec ["groupChat", 0];
        ["success", true, true] remoteExec ["BIS_fnc_endMission", 0, true];
    };

    // Nuke task
    [
        playerGroup,
        "recoverNuke",
        [
            "Alpha 1-2 reported the empty Russian tactical nuke launch vehicle.",
            "[OPTIONAL] Recover nuke"
        ],
        nuke,
        "CREATED",
        50,
        true
    ] call BIS_fnc_taskCreate;
    [] spawn {
        // Wait until the nuke is checked
        while {{_x in playerGroupUnits} count (crew nuke) == 0} do {sleep 1};

        _closestUnits = [playerGroupUnits, [], {nuke distance _x}, "ASCEND"] call BIS_fnc_sortBy;
        _closestUnit = _closestUnits select 0;
        if (fuel nuke > 0) then {
            [_closestUnit, "I recovered the nuke carrier"]
                remoteExec ["groupChat", 0];
        } else {
            [_closestUnit, "I checked the nuke carrier. It is empty and has no fuel."]
                remoteExec ["groupChat", 0];
            // Wait until the nuke is fueled.
            while {fuel nuke < 0.01} do {sleep 1};
        };
        sleep 3;
        [playerGroupCommander, "This is Alpha 1-1. We recovered the tactical nuke launch vehicle."]
            remoteExec ["commandChat", 0];
        sleep 1;
        ["recoverNuke", "SUCCEEDED", true] call BIS_fnc_taskSetState;
    };

    // Ammo box task
    [
        playerGroup,
        "lootAmmoBox",
        [
            "Russian forces abandoned a shipment of ammunition at the military base several days ago. " +
                "Recover it if it is still intact.",
            "[OPTIONAL] Recover the ammunition"
        ],
        ammoBox,
        "CREATED",
        30,
        true
    ] call BIS_fnc_taskCreate;
    [] spawn {
        // Wait until the ammo box is found
        while {{_x distance ammoBox < 3} count playerGroupUnits == 0} do {sleep 1};

        ["lootAmmoBox", "SUCCEEDED", true] call BIS_fnc_taskSetState;
        _closestUnits = [playerGroupUnits, [], {ammoBox distance _x}, "ASCEND"] call BIS_fnc_sortBy;
        _closestUnit = _closestUnits select 0;
        [_closestUnit, "I found the Russian ammunition."]
            remoteExec ["groupChat", 0];
        sleep 5;
        [playerGroupCommander, "This is Alpha 1-1. We've recovered the Russian ammunition."]
            remoteExec ["commandChat", 0];
    };
};
