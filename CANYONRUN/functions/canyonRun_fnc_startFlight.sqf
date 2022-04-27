/*
Canyon run, by woofer.
canyonrun_fnc_startFlight

Starts the run for the given player and aircraft and handles all events during the run

Params: [ BIS_fnc_simpleObjectData , _aircraft ]							
Return: [ none ]										
*/

systemChat "startFlight ran";


private _pilot = _this select 0;    // Pilot unit passed to this function


// http://killzonekid.com/arma-scripting-tutorials-kk_fnc_setdirfly/
KK_fnc_setDirFLY = {
    private ["_veh","_dir","_v"];
    _veh = _this select 0;
    _dir = _this select 1;
    _v = velocity _veh;
    _veh setDir _dir;
    _veh setVelocity [
        (_v select 1) * sin _dir - (_v select 0) * cos _dir,
        (_v select 0) * sin _dir + (_v select 1) * cos _dir,
        _v select 2
    ];
};


// Get the current pilot data at the beginning of the run
_pilotUID   = (canyonRun_var_playerList select 0) select 0; // UID of the pilot
_name       = (canyonRun_var_playerList select 0) select 1;
_aircraft   = (canyonRun_var_playerList select 0) select 2;
_points     = (canyonRun_var_playerList select 0) select 3;
_hiScore    = (canyonRun_var_playerList select 0) select 4;

_pilot = canyonRun_var_currentPilot;


// Now we are actually ready to reorder the player list so that we get the next dude in line correctly
// In case someone wants to manipulate the order during someone else's run
[_pilotUID,false,true] call canyonRun_fnc_playerQueue; // Move player of this UID to last in queue


private _endRun = false;



// ------------------------------------- Put pilot in plane -------------------------------------

// Spawn aircraft at the starting location and make it fly
_aircraftObject = createVehicle [_aircraft, getPos startLocation, [], 0, "FLY"];
canyonRun_aircraft = _aircraftObject;
//_tempPilot = createVehicle ["B_Pilot_F", getPos startLocation, [], 0 ];

// Set the vehicle pointing the correct starting direction.
[_aircraftObject, 60] call KK_fnc_setDirFLY;

// Put the player into the cockpit
_pilot moveInDriver _aircraftObject;



// ---------------------------------------- ENDSTATES ----------------------------------------

// When unit is killed
_pilot addEventHandler ["Killed", {
	params ["_unit", "_killer"];
    // Code here that will execute on triggering of this EH
    canyonRun_var_activeRun = false;
    // Should probably clean the EH up here immediately
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

// When a pilot gets out of aircraft, bails or disconnects
// If assigned to aircraft, use GetOut here
_pilot addEventHandler ["GetOutMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
    // Code here that will execute on triggering of this EH
    canyonRun_var_activeRun = false;
    _unit setDamage 2;
    // Should probably clean the EH up here immediately
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

// When a pilot achieves the win condition
canyonRun_fnc_winCondition = {
    // Some code for checking for that or we'll make the goal execute the event
    canyonRun_var_activeRun = false;
};



// ---------------------------------------- Active run state ----------------------------------------
// Now we are airborne and all tracking is set up
// This is the part where we do all the flying and points counting







// --------------------------------- Check for the end of the run ----------------------------------

[] spawn {

    while {canyonRun_var_activeRun} do {

        // Check things
        sleep 1;

    };
};


waitUntil {!canyonRun_var_activeRun};



// ------------------------------------- Hand off to main loop--------------------------------------
