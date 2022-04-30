/*

This is the main game loop and should only run on the server


*/


// Halt the loading of the scenario code until someone initializes it
waitUntil {canyonRun_var_scenarioLive};


// --------------------------------- START OF MAIN LOOP ---------------------------------------

while {true} do { // for now no need to be able to stop this loop, people will have to disconnect.
	
	canyonRun_var_activeRun = false;

	// Make all machines show the spawn flag on the oberservation screen
	// Passing some temporary values - need params with default values
	["spawn",player,[1,1,1]] remoteExec ["canyonRun_fnc_observerScreen"];



	// Show a countdown on each machine before the next run initiates
	[0,{
		// First we need a countdown timer between runs
		// Let's display it as a hint for now,
		// but would look nicer as a message every ten seconds before counting down the last few seconds.
		// This should be synced up between clients using mission time

		for "_i" from 10 to 0 step -1 do {
			_pilotName = (canyonRun_var_playerList select 0) select 1;
			hintSilent format ["Next pilot %1 to start in %2 seconds", _pilotName,_i];
			sleep 1;
		};
		hintSilent ""; // Clear the hint

		// Only the server needs this, but for now it's set on all clients right after the counter is done
		canyonRun_var_activeRun = true;
	}] call canyonRun_fnc_clientCode;

	waitUntil {canyonRun_var_activeRun};

	// Set up enemies for this run
	[] call canyonRun_fnc_enemyStart;

	// Now that we counted down, it's time to start the run
	_pilotUID   = (canyonRun_var_playerList select 0) select 0; // UID of the pilot
	_pilot = _pilotUID call BIS_fnc_getUnitByUID;
	_pilotClientID = owner _pilot;	// ClientID converted from UID
	
	canyonRun_var_currentPilot = _pilot; // Store for easy access during the run
		
		


	// Get the current pilot data at the beginning of the run
	_pilotUID   = (canyonRun_var_playerList select 0) select 0; // UID of the pilot
	_name       = (canyonRun_var_playerList select 0) select 1;
	_aircraft   = (canyonRun_var_playerList select 0) select 2;
	_lastScore  = (canyonRun_var_playerList select 0) select 3;
	_hiScore    = (canyonRun_var_playerList select 0) select 4;

	

	// Now we are actually ready to reorder the player list so that we get the next dude in line correctly
	// In case someone wants to manipulate the order during someone else's run
	[_pilotUID,"last"] call canyonRun_fnc_playerQueue; // Move player of this UID to last in queue





	// This might mean timing issues but we'll leave that to tomorrow me
	_pilotClientID publicVariableClient "canyonrun_fnc_runFlight";
	[_pilotUID] remoteExec ["canyonrun_fnc_runFlight",_pilotClientID];
	
	// Run the camera setup on all machines except where the current pilot is local
	// The observation point will have to be different depending on aircraft probably
	["runFlight", _pilot, [0,-10,5]] remoteExec ["canyonRun_fnc_observerScreen"];


	// Wait for the flying client to end their run or disconnect
	[] spawn {
		while {canyonRun_var_activeRun} do {
			// Check things
			sleep 1;
		};
	};

	waitUntil {!canyonRun_var_activeRun};

	// Now that the flight is done, do stuff

	
	// Get rid of enemies
	[] call canyonRun_fnc_enemyStop;




}; // End of main loop

