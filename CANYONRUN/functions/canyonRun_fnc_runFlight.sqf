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

canyonRun_var_runScore = 0;



// Looks like the function in the trigger is executed on every machine as the plane goes through
/*
https://community.bistudio.com/wiki/6thSense.eu/EG#Locality
Triggers created in editor exist on all machines (a trigger is created per machine, local to it),
and they run on all machines (conditions checked, onActivation/onDeActivation
executed when condition is true etc)

So it would seem that I need to make sure point get is either only run on the pilot's client
or only on the server

*/
canyonRun_fnc_pointGate = {
	canyonRun_var_runScore = canyonRun_var_runScore + 1;
    hint format ["the point! now %1 point!",canyonRun_var_runScore];
};



private _aircraftType = (canyonRun_var_playerList select 0) select 2;

// If the current pilot is fully watching through the observation screen, turn that shit off.
canyonrun_var_camera cameraEffect ["internal", "BACK","stream"];

// ------------------------------------- Put pilot in plane -------------------------------------


// Spawn aircraft at the starting location and make it fly
_aircraftObject = createVehicle [_aircraftType, getPos startLocation, [], 0, "FLY"];

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




// ---------------------------------------- Active run ----------------------------------------

// Out of bounds detection
// I should put in a warning mechanic that gives you a few seconds to get back into safe air
canyonRun_fnc_outOfBounds = {
    params ["_unit"];
	//_unit setdamage 10;
	systemChat "out of bounds";
};

// Check for altitude
// I should put in a warning mechanic that gives you a few seconds to get back into safe air
[_pilot] spawn {
    params ["_unit"];

    while {canyonRun_var_activeRun} do {
        _altitude = ((getPosATL _unit) select 2);		// Get the current altitude above ground
        
        if ( _altitude > 200 ) exitWith {
            //_unit setDamage 10;						// When you're too high, you die for now
            systemChat "too high!";
        };
    };
};


// Get the fuel leak going
[_aircraftObject] spawn canyonRun_fnc_fuelLeak;


// ---------------------------------------- End of run ----------------------------------------

waitUntil {!canyonRun_var_activeRun};

// Pass the score of this pilot to the server for updating of the player list ON the server
[_pilotUID,canyonRun_var_runScore] remoteExec ["canyonRun_fnc_updateScore",2];





// ------------------------------------- Hand off to main loop--------------------------------------
