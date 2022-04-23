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

		// Let the client know there is now a canyon run going
		canyonRun_var_activeRun = true;
	}] call canyonRun_core_clientCode;



	// While we are waiting for the countdown, set up enemies
	[] call canyonRun_fnc_enemyStart;

	waitUntil {canyonRun_var_activeRun};

	// Now that we counted down, it's time to start the run
	[] call canyonRun_fnc_startFlight;

	// This is the part where we do all the flying and points counting
	waitUntil {!canyonRun_var_activeRun};

/*
A few tings to investigate:
- Will the server be able to easily set the fuel of the target aircraft? Should function run on client?
- Attaching the smoke shells on the aircraft will probably have to be done locally by the client
- Should I have the target client spawn the aircraft or will moveInDriver fix locality for us?

Should each client have the function startFlight and be made to run it?
*/



	// Do all that is needed to end the run
	[] call canyonRun_fnc_startFlight;

}; // End of main loop
