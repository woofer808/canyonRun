/*
*										Canyon Run, by woofer.
*
*									Aircraft survival scenario
*
*	A multiplayer aircraft survival mission with a number points system where the player has to fuel.
*	run a low-altitude gauntlet of anti-air units with limited fuel.
*
*	Definitions:
*	- Scene: A predefined camera angle with camera movement along with take time, fov and so on.
*	- Variable names: canyonRun_var_variableName
*	- Function and script names: canyonRun_fnc_functionOrScriptName(.sqf)
*	- Object names: canyonRun_objectName
*
*	Game loop:
*	You have a broken fuel pump. The more gas you give, the more fuel gets dumped overboard.
*	To make things worse, you are in hostile territory where enemies are testing their Anti-air laser systems.

*	- Don't raise above 200m above ground or you'll get insta-lazored.
*	- Don't go into the testing zones outside of the canyon or get burninated.
*	- Don't give too much throttle, or you'll loose your fuel before getting out.
*	- Don't get shot down by the conventional anti-air units on the ground.
*
*	Gameplay loop: Select player and aircraft. Run the canyon until finish or crash. Record score. Repeat
*	
*	Concept shamelessly stolen from https://www.youtube.com/watch?v=H3wqcjzXr78
*/


/* ------------------------------ PROJECT PLAN ----------------------------------------
The game loop:
Fly through the terrain while loosing fuel as far through the maze as possible,
without crashing, going out of bounds or being shot down.

What makes it fun:
Made to play as a party game where you get to watch each friend's run together through
an in-game provided follow camera.

What makes it last:
Editor skilled game masters can change up the route or enemy configuration between sessions.

----------------------------------- ROADMAP --------------------------------------------
Functionality for alpha should be:
- locality written for MP from the ground up, the server is boss
- load into the scenario without issue
- pilot order is set as in lobby and possible JIP
- option to start mission at the beginning
- one minute between automated runs, no manual starts at will
- only one aircraft that is tuned which means no selection
- enemies on ground during each run
- score tracking
- camera feed at camp

Functionality for beta should be:
- game master
- GUI for game master
- several aircraft
- GUI for players selection of aircraft
- instructions in diary
- markers/explanations on map
- instructions in camp
- scoreboard
- win condition or max score condition
- suggestions

Functionality for release should be:
- as many aircraft configured as possible
- suggestions

-------------------------------------------------------------------------------------- */

//REDO- Do we want a game master or should there be a timed automated pass-around of controls. Need a way to minimize griefing
//REDO- Make it so that every round start and stop is done by the server
//REDO- Every regular non-playing player can only update their preferred aircraft for now
//REDO- Need a way to pass game master around

//TODO- Make the server update all the clients so that they see each new run through the observer screen
//TODO- Game master needs to retain the option of starting the interface between deaths
//TODO- Build system that keeps track of current game state
//TODO- Camera should always run, but be aimed at the current aircraft
//IDEA- Make camera use different spots for each section of the circuit
//IDEA- TFAR pre-configured channels for aircraft and radios on pilots


// Debug and development mode switches
canyonRun_var_debug = true;
canyonRun_var_devMode = true;
canyonRun_var_pilot = 0;
canyonRun_var_aircraft = 0;
canyonRun_var_pilot = player;





// Functions to be compiled
canyonRun_fnc_compileAll = {

	canyonRun_fnc_playerManagement = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_playerManagement.sqf";
	canyonRun_fnc_debug = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_debug.sqf";
	canyonRun_fnc_planeList = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_planeList.sqf";
	canyonRun_fnc_fuelLeak = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_fuelLeak.sqf";
	canyonRun_fnc_startFlight = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_startFlight.sqf";
	canyonRun_fnc_endFlight = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_endFlight.sqf";
	canyonRun_fnc_enemies = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_enemies.sqf";
	canyonRun_fnc_observerScreen = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_observerScreen.sqf";
	canyonRun_fnc_score = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_score.sqf";

};
[] call canyonRun_fnc_compileAll;

// Global variables initialization on all clients and server
canyonRun_var_missionGo = false;		// Used to initialize mission on all clients to let server do the startup



if (isServer) then {	// run on dedicated server or player host
	
	[] call canyonRun_fnc_playerManagement; // This will take proper action when people join or leave the session

	/*	
	*
	*	The server will generate a list of available aircraft and broadcast that to all the clients.
	*
	*/

	// I really need an array with all the aircraft and their names, but the planes class contains UAV's. Gotta filter it.
	// The only solution I could think of was to gather all the plane classnames, spawn each vehicle and use unitIsUAV to filter UAV's
	// configClasses will generate a list of paths for each class
	_classNamesPlanes = "getNumber (_x >> 'scope') >= 2 AND configName _x isKindof 'Plane'" configClasses (configFile >> "CfgVehicles");
	
	// Populate the array with non-uav aircraft from the list of classes.
	// Set up array to store the acceptable aircraft types
	canyonRun_var_aircraftList = [];
	{

		
		// Spawn the aircraft
		// To get just the short config name from a class: (configName _x);
		_tempAircraft = createVehicle [(configName _x), [0,0,(random [500,1000,1500])], [], 0, "NONE"];

		// Check if UAV
		_isUAV = unitIsUAV _tempAircraft;

		// If the vic isn't a UAV, add it to the aircraft list along with it's pretty name
		if !(_isUAV) then {
			// Put the vic in the array
			canyonRun_var_aircraftList pushBack [[_x] call BIS_fnc_displayName,configName _x];
		};

		// Delete the temporary aircraft
		deleteVehicle _tempAircraft;

	} forEach _classNamesPlanes;
	// Make sure all the clients and JIP get the array for use in their selection
	publicVariable "canyonRun_var_aircraftList";

	// Set the variable for mission go to let each client start loading code
	missionNamespace setVariable ["canyonRun_var_missionGo", true, true];

	
	// Initialize enemies only run by the server
	[] call canyonRun_fnc_enemies;

	
	// ---------------------------------------------------------------------
	//					Single player specific code
	// ---------------------------------------------------------------------
	// If we're playing single player, remove all the AI
	if (!isMultiplayer) then {
		// Remove all other playable units
		{deleteVehicle _x} forEach ([p0,p1,p2,p3,p4,p5,p6,p7,p8,p9] - [player]);
	}; // End of single player specific code




};	// End of server-side only executed code





if (hasInterface) then {	// run on all player clients incl. player host

	waitUntil {canyonRun_var_missionGo};

	// Let each player execute the GUI
	[] execVM "CANYONRUN\canyonRun_gui\canyonRun_gui_init.sqf";

	
	// This is a debug counter for current number of units on the terrain thay only runs on mission start
	[] spawn {
		if canyonRun_var_debug then {
			while {canyonRun_var_debug == true} do {
			_blueUnits 	= count (allUnits select {side _x == west});
			_redUnits 	= count (allUnits select {side _x == east});
			hintSilent format ["Unit count west: %1, east: %2", _blueUnits, _redUnits]};
			sleep 1;
		};
	};





	// ---------------------------------------------------------------------
	//					Observer screen initialization
	// ---------------------------------------------------------------------
	// BIKI says only a local camera can be entered into - so cameras are local to players.
	// This code is run on every machine unless it's a headless

	// Set the screen texture to the image stream from the camera
	canyonRun_var_screen setObjectTexture [0, "#(argb,512,512,1)r2t(stream,1)"];

	/* create camera and stream to render surface */
	canyonRun_var_camera = "camera" camCreate (canyonRun_var_spawnFlag modelToWorld [20,15,10]);
	canyonRun_var_camera cameraEffect ["Internal", "Back", "stream"];
	"stream" setPiPEffect [0];			// Set the proper camera effect

	detach canyonRun_var_camera;
	canyonRun_var_camera camSetTarget canyonRun_var_spawnFlag;
	canyonRun_var_camera camCommit 0;

	// Give player option to go fullscreen on the camera
	canyonRun_var_screen addAction ["fullscreen observation",
		{
			canyonrun_var_camera cameraEffect ["internal", "BACK"];
			systemChat "----> Press F1 to get out of camera";

			[] spawn {
				//moduleName_keyDownEHId = (findDisplay 46) displayAddEventHandler ["KeyDown", "hint str _this;"];
				waituntil {(inputAction "SelectGroupUnit1" > 0)};
				canyonrun_var_camera cameraEffect ["internal", "BACK","stream"];
				systemChat "key pressed";
			};
		}
	];





// TEMPORARY: Should probably only be executed by the game master even though each player need to be able to choose aircraft
// Give the spawn flag option to start the run
canyonRun_var_spawnFlag addAction ["run",{_handle=createdialog "canyonRun_gui_dialogMain"}];




};	// End of hasInterface executed code



// This has to be moved to some sort of game mechanic sqf
canyonRun_fnc_outOfBounds = {
	canyonRun_pilot setdamage 10;
	systemChat "out of bounds";
};