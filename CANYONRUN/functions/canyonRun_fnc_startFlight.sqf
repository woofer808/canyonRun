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






// Reset the flightPoints
canyonrun_var_flightPoints = 0;







// Set up enemies
[] call canyonRun_fnc_enemyStart;







private _pilot 	    = _this select 0;
private _aircraft 	= _this select 1;













// Spawn aircraft at the starting location and make it fly
_aircraftObject = createVehicle [_aircraft, getPos startLocation, [], 0, "FLY"];
canyonRun_aircraft = _aircraftObject;
//_tempPilot = createVehicle ["B_Pilot_F", getPos startLocation, [], 0 ];

// Set the vehicle pointing the correct starting direction.
[_aircraftObject, 60] call KK_fnc_setDirFLY;

// Put the player into the cockpit
(_pilot select 1) moveInDriver _aircraftObject;

// Activate the observer screen for the current pilot
[_pilot,_aircraftObject] remoteExec ["canyonRun_fnc_observerScreen"]; 


// Give the player a few seconds to set throttle
sleep 3;

// Get the fuel leak going
[] execVM "CANYONRUN\functions\canyonRun_fnc_fuelLeak.sqf";
