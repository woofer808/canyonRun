
/*
*										Canyon Run, by woofer.
*
*									Aircraft survival scenario
*
*	A multiplayer aircraft survival mission with a number points system where the player has to fuel.
*	run a low-altitude gauntlet of anti-air units with limited fuel.
*
*	Definitions:
*	- Variable names: canyonRun_var_variableName
*	- Function and script names: canyonRun_fnc_functionOrScriptName(.sqf)
*	- Object names: canyonRun_objectName
*
*	Game idea:
*	You have a broken fuel pump. The more gas you give, the more fuel gets dumped overboard.
*	To make things worse, you are in hostile territory where enemies are testing their Anti-air laser systems.
*
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
Fly through the terrain while loosing fuel as far through the maze as possible
without crashing, going out of bounds or being shot down.

What makes it fun:
Made to play as a party game where everybody get to watch each friend's run together through
an in-game provided follow camera.

What makes it last:
Editor skilled game masters can change up the route or enemy configuration between sessions.

----------------------------------- ROADMAP --------------------------------------------
Functionality for alpha should be:
x locality written for MP from the ground up, the server is boss
x load into the scenario without issue
x pilot order is set as in lobby and possible JIP
x option to start mission at the beginning on the flag
x one minute between automated runs, no manual starts at will
x only one aircraft that is tuned which means no selection
x fresh editor placed enemies on ground during each run
x score tracking
x hiscore tracking
x camera feed at camp
x Out of bounds mechanic
x Fuel depletion mechanic

Functionality for beta should be:
- map tracking along with current fuel level and name (local on each client, I suppose)
- GUI for players selection of aircraft
- kill messages (killed by enemy or crash)
- JIP verification
- Live monitoring of aircraft fuel level for all players
x game master
- GUI for game master
- several aircraft
- GUI for changing player queue order by game master
- mission markers/explanations on map
- scoreboard
x instructions in diary
- instructions in camp
- win condition or max score condition
x CBA option for exiting observation screen
x Sound effect for engine failure
x visual cue for engine failure
- Explore replay with either 2D map version or with unitcapture decide on feasability
- suggestions

Functionality for release should be:
- as many aircraft configured as possible
- Cleanup of code and commenting with proper headers
- Optimize file sizes
- Enviroment controls (daytime/nighttime and weather)
- Update diary to final features
- suggestions

-------------------------------------------------------------------------------------- */

//KNOWN- Intel on table has a default action of "take intel" - use for easter egg/enemy pos?
//KNOWN- Point get audio is played on all clients
//TODO- High score message for clients is shown only on server
//TODO- CompileAll misses to recompile the gui - maybe compileInit and compileGui and compileAll
//TODO- Test fnc_playerQueue to have it move people to next in queue
//TODO- 
//TODO- Update clientCode to work in SP conditions sith SP_PLAYER UID
//TODO- Scenario should automatically go live when there is a game master in the slot
//TODO- Put an eventhandler on p0 so that the scripts know when he is connecting or disconnecting
//TODO- JIP players should be told scenario is live upon connecting.
//TODO- Game master leaving or connecting should be shown to all players
//TODO- Move function compilation onto the server and publicVariable as needed
//TODO- set a default aircraft that isn't from a DLC
//TODO- No good for a party game if you can't distinguish between players. Make them dress diffrently
//IDEA- Mark player crashes on the map in some good way - maybe the latest only?
//IDEA- Gunner positions - let other people fly along
//IDEA- Make camera use different spots for each section of the circuit
//IDEA- TFAR pre-configured channels for aircraft and radios on pilots
//IDEA- Cleanup old wrecks/replace with 3d icons?
//IDEA- Randomization option for aircraft
//IDEA- Gruppe Adler-like replay functionality for runs or use 



// ----------------------------------CURRENTLY AT:--------------------------------------
// ----------------------------------CURRENTLY AT:--------------------------------------
/* 

map markers. best bet for now seems to be drawPolygon or get back into the bog of icons

GUI - need a list and button selection for next pilot as with indicam "set actor list"
drop-down needs to update the text in the window top better. it's a bit hit or miss right now
will likely get better with the new list system
I seem to be able to break the aircraft selection in mp as well. I keep getting p1's plane
update: looks like it's the sorting function. If i select same person the current pilot changes
but only if i keep selecting number two in the list. index 0 keeps landing on p0
actually only the second selection makes any changes

I don't really want the selection from game master to overwrite each client's

Add a test that detects when the game master slot becomes empty. When detected:
	- Show a warning that the game master has left
	- Show a warning that the system will start looping games automatically in a minute
	  or so unless the game master slot becomes occupied again.



Put compiling of functions on the server, but publicVariable the ones that need to be
local to each client. decide which goes where.

Add variableEventhandler to all clients and server in order to keep the list of

Add a test to each client that tests and possibly removes any aircraft classnames from the list
that it hasn't got loaded - this to prevent the server giving options that the client can't use
also tell the client that they do not have the same asset mods loaded as the server

screen stream isn't running anymore it seems

Flight data is now in for the player.
Gonna need to decide if the player should be able to even see it, but it needs localization
so that other player get to see it.
Either the player does the calculation and sends over network, or each client will have to pull
the info by themselves. not sure yet. I want it updating at 0.3 seconds. is that too much to
send over the network?


*/
// ----------------------------------CURRENTLY AT:--------------------------------------
// ----------------------------------CURRENTLY AT:--------------------------------------





// Debug and development mode switches
canyonRun_var_debug = true;
canyonRun_var_devMode = true;
canyonRun_var_aircraft = "I_Plane_Fighter_04_F";
canyonRun_var_pilot = player;
canyonRun_var_scenarioLive = false;	// variable to start the scenario
canyonRun_var_activeRun = false; // Used to indicate wether there is an active run currently going on


if (isServer) then {	// run on dedicated server or player host

	// Functions to be compiled
	canyonRun_fnc_compileAll = {

		canyonRun_core_mainLoop = compile preprocessFileLineNumbers "CANYONRUN\canyonRun_core_mainLoop.sqf";
		//publicVariable "canyonRun_core_mainLoop"; // Serverside only
		canyonRun_fnc_playerManagement = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_playerManagement.sqf";
		publicVariable "canyonRun_fnc_playerManagement";
		canyonRun_fnc_playerQueue = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_playerQueue.sqf";
		publicVariable "canyonRun_fnc_playerQueue";
		canyonRun_fnc_debug = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_debug.sqf";
		publicVariable "canyonRun_fnc_debug";
		canyonRun_fnc_planeList = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_planeList.sqf";
		publicVariable "canyonRun_fnc_planeList"; // Send to clients
		canyonRun_fnc_fuelLeak = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_fuelLeak.sqf";
		publicVariable "canyonRun_fnc_fuelLeak"; // Send to clients
		canyonrun_fnc_runFlight = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonrun_fnc_runFlight.sqf";
		publicVariable "canyonrun_fnc_runFlight"; // Send to clients
		canyonRun_fnc_enemies = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_enemies.sqf";
		//publicVariable "canyonRun_fnc_enemies"; // Serverside only
		canyonRun_fnc_observerScreen = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_observerScreen.sqf";
		publicVariable "canyonRun_fnc_observerScreen";
		canyonRun_fnc_updateScore = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_updateScore.sqf";
		publicVariable "canyonRun_fnc_updateScore";
		canyonRun_fnc_clientCode = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_clientCode.sqf";
		publicVariable "canyonRun_fnc_clientCode";
		canyonRun_fnc_mapTracking = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_mapTracking.sqf";
		publicVariable "canyonRun_fnc_mapTracking";
		canyonRun_fnc_flightData = compile preprocessFileLineNumbers "CANYONRUN\functions\canyonRun_fnc_flightData.sqf";
		publicVariable "canyonRun_fnc_flightData";
		fnc_test = compile preprocessFileLineNumbers "CANYONRUN\fnc_test.sqf";
		publicVariable "fnc_test";
		
		if (canyonRun_var_debug) then {
			["scripts compiled"] call canyonRun_fnc_debug;
		};

	};
	[] call canyonRun_fnc_compileAll;



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
			canyonRun_var_aircraftList pushBack [configName _x,[_x] call BIS_fnc_displayName];
		};

		// Delete the temporary aircraft
		deleteVehicle _tempAircraft;

	} forEach _classNamesPlanes;
	// Make sure all the clients and JIP get the array for use in their selection
	publicVariable "canyonRun_var_aircraftList";

	
	// Initialize enemies only run by the server
	[] call canyonRun_fnc_enemies;


	// Draw a rectangle over every trigger placed in the editor containing the word "boundry"
	_list = allMissionObjects "EmptyDetector";
	{
	_search = ["boundry", str _x, false] call BIS_fnc_inString;
		if (_search) then {
			_pos = getPos _x;
			_dimX = (triggerArea _x) select 0;
			_dimY = (triggerArea _x) select 1;
			_rotZ = (triggerArea _x) select 2;

			_myMarkerName= format ["%1",str _x];
			_myMarker = createMarker [_myMarkerName, _pos];
			_myMarker setMarkerSize [_dimX,_dimY];
			_myMarker setMarkerDir _rotZ;
			_myMarker setMarkerShape "RECTANGLE"; 
		};
	} forEach _list;


	// ---------------------------------------------------------------------
	//					Single player specific code
	// ---------------------------------------------------------------------
	// If we're playing single player, remove all the AI
	if (!isMultiplayer) then {
		// Remove all other playable units
		{deleteVehicle _x} forEach ([p0,p1,p2,p3,p4,p5,p6,p7,p8,p9] - [player]);
	}; // End of single player specific code

	// This is where the gameplay loop should kick off
	[] spawn canyonRun_core_mainLoop;






};	// End of server-side only executed code



if (hasInterface) then {	// run on all player clients including player host


	// Initialize the diary entry
	[] execVM "CANYONRUN\canyonRun_core_diary.sqf";
	
	// Let each player execute the GUI
	[] execVM "CANYONRUN\canyonRun_gui\canyonRun_gui_init.sqf";



	// This is to keep track of when the server sends a variable
	"canyonRun_var_aircraftProperties" addPublicVariableEventHandler {
		systemchat format ["%1 has been updated to: %2",_this select 0,_this select 1];
	};


	// ---------------------------------------------------------------------
	//					Observer screen initialization
	// ---------------------------------------------------------------------
	// BIKI says only a local camera can be entered into - so cameras are local to players.
	// This code is run on every machine unless it's a headless

	// Set the screen texture to the image stream from the camera
	canyonRun_var_screen setObjectTexture [0, "#(argb,512,512,1)r2t(stream,1)"];

	// create camera and stream to render surface
	canyonRun_var_camera = "camera" camCreate (canyonRun_var_spawnFlag modelToWorld [20,15,10]);
	canyonRun_var_camera cameraEffect ["Internal", "Back", "stream"];
	"stream" setPiPEffect [0];			// Set the proper camera effect

	detach canyonRun_var_camera;
	canyonRun_var_camera camSetTarget canyonRun_var_spawnFlag;
	canyonRun_var_camera camCommit 0;





		/* -------------------------------------------------------------------------------------------------------
			Open GUI - F1-key
		   ------------------------------------------------------------------------------------------------------- */
		// Define the function that is to run when the CBA bound key is pressed.
		canyonRun_fnc_keyGUI = {
			// Only open the dialog if it's not already open
			if (isNull (findDisplay canyonRun_id_guiDialogMain)) then {createDialog "canyonRun_gui_dialogMain";} else {closeDialog 0};
			["F1-key pressed.",true,true] call canyonRun_fnc_debug;
		};

		// Assign the key depending on CBA being loaded or not
		if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {

			// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
			["canyonRun","guiKey", ["show control window", "Show or hide canyonRun controls."], {_this spawn canyonRun_fnc_keyGUI}, {}, [59, [false, false, false]]] call CBA_fnc_addKeybind;

		} else {
			
			// This key needs to be persistent
			[] spawn {
				while {true} do {
					waituntil {(inputAction "SelectGroupUnit1" > 0)};
					[] spawn canyonRun_fnc_keyGUI;
					waituntil {inputAction "SelectGroupUnit1" <= 0};
				};
			};
		};

		/* -------------------------------------------------------------------------------------------------------
		    Stop camera  - F2-key
	   	   ------------------------------------------------------------------------------------------------------- */
		canyonRun_fnc_keyExitCamera = {
			canyonrun_var_camera cameraEffect ["internal", "BACK","stream"];
			["F2-key pressed.",true,true] call canyonRun_fnc_debug;
		 };

		// Assign the key depending on CBA being loaded or not
		if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {

			// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
			["canyonRun","stopCamera", ["stop observation camera", "Shuts down the observation camera if it has been entered into."], {_this spawn canyonRun_fnc_keyExitCamera}, {}, [60, [false, false, false]]] call CBA_fnc_addKeybind;

		} else {
			
			// This key needs to be persistent
			[] spawn {
				while {true} do {
					waituntil {(inputAction "SelectGroupUnit2" > 0)};
					[] spawn canyonRun_fnc_keyExitCamera;
					waituntil {inputAction "SelectGroupUnit2" <= 0};
				};
			};
		};



	// Give player option to go fullscreen on the camera
	canyonRun_var_screen addAction ["fullscreen observation",
		{
			canyonrun_var_camera cameraEffect ["internal", "BACK"];
			systemChat "----> Press F2 to get out of camera (or key you bound in CBA settings)";
		}
	];



	// TEMPORARY: Should probably only be executed by the game master even though each player need to be able to choose aircraft
	// Addaction to be removed and added into the GUI
	canyonRun_var_spawnFlag addAction ["start scenario",{
		// Set the scenario loose by setting the varible to true and broadcasting it to all clients
		missionNamespace setVariable ["canyonRun_var_scenarioLive", true, true];
		
		// Clearly display that the scenario is now live
		{cutText ["<t color='#00ff00' size='4'>Scenario is LIVE!</t>", "PLAIN DOWN", 0.3, true, true]} remoteExec ["call",0];

		// str _this = [object_var,activatingPlayer,actionID,<null>]
		canyonRun_var_spawnFlag removeAction (_this select 2); // removes this addAction
	}];

	// Also temporary - Should be instructions in camp
	canyonRun_var_spawnFlag addAction ["controls",{
		createDialog "canyonRun_gui_dialogMain";
	}];


};	// End of hasInterface executed code


