/*

This is the main game loop and should only run on the server


*/


// Halt the loading of the scenario code until someone initializes it
waitUntil {canyonRun_var_scenarioLive};


// --------------------------------- START OF MAIN LOOP ---------------------------------------

while {true} do { // for now no need to be able to stop this loop, people will have to disconnect.
	
	canyonRun_var_activeRun = false;

	// Show a countdown on each machine before the next run initiates
	[0,{
		// First we need a countdown timer between runs
		// Let's display it as a hint for now,
		// but would look nicer as a message every ten seconds before counting down the last few seconds.

		for "_i" from 10 to 0 step -1 do {
			_pilotName = (canyonRun_var_playerList select 0) select 1;
			hintSilent format ["Next pilot %1 to start in %2 seconds", _pilotName,_i];
			sleep 1;
		};
		hintSilent ""; // Clear the hint

		// Only the server needs this, but for now it's set on all clients right after the counter is done
		canyonRun_var_activeRun = true;
	}] call canyonRun_core_clientCode;

	waitUntil {canyonRun_var_activeRun};

	// Now that we counted down, it's time to start the run
	_pilotUID   = (canyonRun_var_playerList select 0) select 0; // UID of the pilot
	_pilot = _pilotUID call BIS_fnc_getUnitByUID;	
	
	canyonRun_var_currentPilot = _pilot; // Store for easy access during the run
		
	[_pilot] call canyonRun_fnc_startFlight;





}; // End of main loop

