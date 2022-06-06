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



	// Each machine need to either wait for the game master to start people on their run
	// or in the case of no game master they will wait for the roundtime counter to finish
	[0,{
		
		// The timer has a different length depending on whether devMode is on or off
		private _waitTime = 60;
		if (canyonRun_var_devMode) then {
			_waitTime = 20;
		} else {
			_waitTime = 40;
		};

		// Detect whether there is someone in the game master slot
		private _gameMaster = call canyonRun_fnc_gameMasterCheck;
		if (_gameMaster) then {

			// Wait for something if there is a game master
			canyonRun_var_gameMasterHold = true;
			waitUntil {!canyonRun_var_gameMasterHold && !canyonRun_var_activeRun};

		} else {

			for "_i" from _waitTime to 1 step -1 do {
				_pilotName = (canyonRun_var_playerList select 0) select 1;
				_text = format ["<t color='#00ff00' size='2'>Next pilot %1 to start in %2 seconds</t>",_pilotName,_i];
				[[_text, "PLAIN DOWN", 0.3, true, true]] remoteExec ["cutText",0];
				sleep 1;
			};
			[["", "PLAIN DOWN", 0.3, true, true]] remoteExec ["cutText",0];

		};


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
	// Publish the current function to the next client to fly
	_pilotClientID publicVariableClient "canyonrun_fnc_runFlight";
	// Then run it on the target client machine
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

