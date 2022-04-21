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

private _damageCoeff = 0.002;								// The basic fuel leak each second.
private _currentFuel = 1;									// Declaration
private _aircraft = canyonRun_aircraft;						// Declaration
private _altitude = ((getPosATL _aircraft) select 2);		// Declaration
private _throttle = airplaneThrottle _aircraft;				// Declaration
private _fuelLoss = 0;										// Declaration
private _throttleCoeff = 0;									// Declaration

private _aircraftProperties = [] call canyonrun_fnc_planeList;	// Get the properties of the current aircraft


// The smoke was originally here to simulate the fuel leak, but right now it's used as a way to illustrate the flight path.
//["eventhandlerName", "onEachFrame", {}] call BIS_fnc_addStackedEventHandler; 
// https://forums.bohemia.net/forums/topic/154379-simple-fire-smoke-effect-added-by-script/
_smokeOne = _aircraftProperties select 5;	// Get position array
_smokeTwo = _aircraftProperties select 6;	// Get position array

smoketheEngine1 = "SmokeShell" createVehicle (position canyonRun_aircraft);smoketheEngine1 attachto [canyonRun_aircraft, _smokeOne];
smoketheEngine2 = "SmokeShell" createVehicle (position canyonRun_aircraft);smoketheEngine2 attachto [canyonRun_aircraft, _smokeOne];
smoketheEngine3 = "SmokeShell" createVehicle (position canyonRun_aircraft);smoketheEngine3 attachto [canyonRun_aircraft, _smokeTwo];
smoketheEngine4 = "SmokeShell" createVehicle (position canyonRun_aircraft);smoketheEngine4 attachto [canyonRun_aircraft, _smokeTwo];

systemChat "-------------> GO!";
while { sleep 1; true } do {								// Here beginneth the loop that shalt loose fuel every second

	_altitude = ((getPosATL canyonRun_aircraft) select 2);		// Get the current altitude
	
	if ( _altitude > 200 ) then {
		//canyonRun_pilot setDamage 10;						// When you're too high, you die for now
		systemChat "too high!";
	};
	
	_throttle = 100 * (airplaneThrottle _aircraft);			// Get the current position of the throttle
	
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
	
	_aircraft setFuel (_currentFuel);						// Drain the fuel

	hintSilent format ["fuel:%1 throttle:%2 loss:%3",_currentFuel,_throttleCoeff,_fuelLoss];

	
	if ((damage _aircraft) >= 1) exitWith {systemChat "aircraft dead"};
	
};

deleteVehicle smoketheEngine1;
deleteVehicle smoketheEngine2;
deleteVehicle smoketheEngine3;
deleteVehicle smoketheEngine4;

