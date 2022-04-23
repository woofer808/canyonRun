/*
Canyon run, by woofer.
canyonrun_fnc_startFlight

Starts the run for the given player and aircraft.		

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




// Get the current pilot data at the beginning of the run
_pilot      = (canyonRun_var_playerList select 0) select 0; // UID of the pilot
_name       = (canyonRun_var_playerList select 0) select 1;
_aircraft   = (canyonRun_var_playerList select 0) select 2;
_points     = (canyonRun_var_playerList select 0) select 3;
_hiScore    = (canyonRun_var_playerList select 0) select 4;

canyonRun_var_currentPilot = _pilot;    // Store for easy access during the run

// Spawn aircraft at the starting location and make it fly
_aircraftObject = createVehicle [_aircraft, getPos startLocation, [], 0, "FLY"];
canyonRun_aircraft = _aircraftObject;
//_tempPilot = createVehicle ["B_Pilot_F", getPos startLocation, [], 0 ];

// Set the vehicle pointing the correct starting direction.
[_aircraftObject, 60] call KK_fnc_setDirFLY;

// Put the player into the cockpit
(_pilot select 1) moveInDriver _aircraftObject;

[] spawn {
    // Give the player a few seconds to set throttle
    sleep 3;
    // Get the fuel leak going
    [] call canyonRun_fnc_fuelLeak.sqf";
};