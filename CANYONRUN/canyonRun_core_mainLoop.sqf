/*

This is the main game loop and should only run on the server


*/


// Halt the loading of the scenario code until someone initializes it
waitUntil {canyonRun_var_scenarioLive};


// --------------------------------- START OF MAIN LOOP ---------------------------------------

while {canyonRun_var_scenarioLive} do {


	// Show a countdown on each machine
	[0,{
		// First we need a countdown timer between runs
		// Let's display it as a hint for now,
		// but would look nicer as a message every ten seconds before counting down the last few seconds.
		for "_i" from 60 to 0 step -1 do {
			hintSilent format ["Time until next run: %1 seconds", _i];
			sleep 1;
		};
		hintSilent ""; // Clear the hint
		canyonRun_var_goFlight = true;
	}] call canyonRun_fnc_clientCode;


// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!THIS IS WHERE WE ARE AT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!THIS IS WHERE WE ARE AT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!THIS IS WHERE WE ARE AT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	// While we are waiting for the countdown, set up enemies
	[] spawn canyonRun_fnc_enemyStart;

	waitUntil {canyonRun_var_goFlight};

	// Now that we counted down, it's time to start the run
	[] spawn canyonRun_fnc_startFlight;

	// This is the part where we do all the flying and points counting 


	// Do all that is needed to end the run
	[] call canyonRun_fnc_startFlight;

}; // End of main loop
