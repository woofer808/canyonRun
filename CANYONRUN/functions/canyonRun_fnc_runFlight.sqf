/*
Canyon run, by woofer.
canyonrun_fnc_runFlight

Starts the run for the given player and aircraft and handles all events during the run

The idea of this is that this script runs on the client of the current pilot

Params: [ BIS_fnc_simpleObjectData , _aircraft ]							
Return: [ none ]										
*/



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


private _pilotUID = _this select 0;

private _pilot = _pilotUID call BIS_fnc_getUnitByUID;

private _endRun = false;

private _aircraft   = (canyonRun_var_playerList select 0) select 2;

// ------------------------------------- Put pilot in plane -------------------------------------



// Spawn aircraft at the starting location and make it fly
_aircraftObject = createVehicle [_aircraft, getPos startLocation, [], 0, "FLY"];
canyonRun_aircraft = _aircraftObject;

// Set the vehicle pointing the correct starting direction.
[_aircraftObject, 60] call KK_fnc_setDirFLY;

// Shove the player into the cockpit
_pilot moveInDriver _aircraftObject;



// ---------------------------------------- ENDSTATES ----------------------------------------


// When unit is killed
player addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    // Code here that will execute on triggering of this EH
    canyonRun_var_activeRun = false;
    publicVariable "canyonRun_var_activeRun";
    
    systemchat format ["%1 failed the run",name _unit];

    // Should probably clean the EH up here immediately
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
    
}];

// When a pilot gets out of aircraft, bails or disconnects
// If assigned to aircraft, use GetOut here
player addEventHandler ["GetOutMan", {
    params ["_unit", "_role", "_vehicle", "_turret"];
    // Code here that will execute on triggering of this EH
    canyonRun_var_activeRun = false;
    publicVariable "canyonRun_var_activeRun";
    _unit setDamage 2;
    
    systemchat format ["%1 failed the run",name _unit];

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









waitUntil {!canyonRun_var_activeRun};



// ------------------------------------- Hand off to main loop--------------------------------------
