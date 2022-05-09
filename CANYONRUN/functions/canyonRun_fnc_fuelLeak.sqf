/*
*-------------------------------------------------------------------------------------------------------
*										Canyon run, by woofer.
*
*										canyonrun_fnc_fuelLeak
*
*	Depletes fuel from an aircraft depending on how much throttle is given.
*
*
*	Params: [ none ]
*
*	Return: [ none ]
*
*-------------------------------------------------------------------------------------------------------
*/

private _aircraftObject = _this select 0;					// Aircraft of the run is passed here

private _damageCoeff = 0.002;								// The basic fuel leak each second.
private _currentFuel = 1;									// Declaration
private _altitude = ((getPosATL _aircraftObject) select 2);	// Declaration
private _throttle = airplaneThrottle _aircraftObject;		// Declaration
private _fuelLoss = 0;										// Declaration
private _throttleCoeff = 0;									// Declaration

private _aircraftProperties = [_aircraftObject] call canyonrun_fnc_planeList;	// Get the properties of the current aircraft


// The smoke was originally here to simulate the fuel leak, but right now it's used as a way to illustrate the flight path.
//["eventhandlerName", "onEachFrame", {}] call BIS_fnc_addStackedEventHandler; 
// https://forums.bohemia.net/forums/topic/154379-simple-fire-smoke-effect-added-by-script/
_smokeOne = _aircraftProperties select 5;	// Get position array
_smokeTwo = _aircraftProperties select 6;	// Get position array

// Give the pilot a slight amount of time after game start to set their throttle
sleep 5;


// Tell the player that their fuel pump broke.
// Kinda wanna use sounds for it, like the hyperjump failure of the millenium falcon or a bang
// So how to play sounds - only need it for the pilot for now, but could maybe use 3d sound for observators
// playSound3D: Plays positional sound with given filename on every computer on network.
// playSound3D [filename, soundSource, isInside, soundPosition, volume, soundPitch, distance, offset, local]
// soundSorce: soundSource: Object - The object emitting the sound. If "sound position" is specified this parameter is ignored
playSound3D ["a3\sounds_f\arsenal\explosives\grenades\explosion_gng_grenades_01.wss", _aircraftObject, false, getPosASL _aircraftObject, 1, 0.4, 0];
playSound3D ["a3\sounds_f\arsenal\explosives\mines\explosion_m6_slam_mine_01.wss", _aircraftObject, false, getPosASL _aircraftObject, 1, 1.7, 0];

// playSound3D doesn't work properly in a moving vehicle. Dive back in when interest comes back
[_aircraftObject] spawn {
	sleep 0.5;
	cutText ["<br/><br/><br/><t color='#ff0000' size='1'>FUEL PUMP ALERT!</t>", "PLAIN", 0.3, true, true];
	playSound3D ["a3\sounds_f\vehicles\air\noises\heli_alarm_rotor_low.wss", vehicle player, false, getPosASL player, 0.5, 0.5, 500,0,true];
	sleep 2;
	playSound3D ["a3\sounds_f\vehicles\air\noises\heli_alarm_rotor_low.wss", vehicle player, false, getPosASL player, 0.5, 0.5, 500,0,true];
	sleep 2;
	playSound3D ["a3\sounds_f\vehicles\air\noises\heli_alarm_rotor_low.wss", vehicle player, false, getPosASL player, 0.5, 0.5, 500,0,true];
};





smoketheEngine1 = "SmokeShell" createVehicle (position _aircraftObject);smoketheEngine1 attachTo [_aircraftObject, _smokeOne];
smoketheEngine2 = "SmokeShell" createVehicle (position _aircraftObject);smoketheEngine2 attachTo [_aircraftObject, _smokeOne];
smoketheEngine3 = "SmokeShell" createVehicle (position _aircraftObject);smoketheEngine3 attachTo [_aircraftObject, _smokeTwo];
smoketheEngine4 = "SmokeShell" createVehicle (position _aircraftObject);smoketheEngine4 attachTo [_aircraftObject, _smokeTwo];


while { sleep 1; true } do {								// Here beginneth the loop that shalt loose fuel every second
	
	_throttle = 100 * (airplaneThrottle _aircraftObject);			// Get the current position of the throttle
	
	switch (true) do {										// Match the aircraft properties to the current throttle position
		case (_throttle > ((_aircraftProperties select 0) select 0)): {_throttleCoeff = (_aircraftProperties select 0) select 1};
		case (_throttle > ((_aircraftProperties select 1) select 0)): {_throttleCoeff = (_aircraftProperties select 1) select 1};
		case (_throttle > ((_aircraftProperties select 2) select 0)): {_throttleCoeff = (_aircraftProperties select 2) select 1};
		case (_throttle > ((_aircraftProperties select 3) select 0)): {_throttleCoeff = (_aircraftProperties select 3) select 1};
		case (_throttle > ((_aircraftProperties select 4) select 0)): {_throttleCoeff = (_aircraftProperties select 4) select 1};
		case (_throttle <= 10): {_throttleCoeff = 0};
	};

	_fuelLoss = _throttleCoeff + _damageCoeff;				// Total fuel loss per second
	_currentFuel = _currentFuel - _fuelLoss;				// Calculate fuel level
	
	_aircraftObject setFuel (_currentFuel);						// Drain the fuel

	//hintSilent format ["fuel:%1 coef:%2 loss:%3",_currentFuel,_throttleCoeff,_fuelLoss];

	// This isn't enough
	// Should also take into account that the player may disconnect
	if (!canyonRun_var_activeRun) exitWith {["No active aircraft, stopping fuel loss function"] call canyonRun_fnc_debug};
	
};

deleteVehicle smoketheEngine1;
deleteVehicle smoketheEngine2;
deleteVehicle smoketheEngine3;
deleteVehicle smoketheEngine4;

