/*
*
*	Render camera to screen script by KillzoneKid
*	http://killzonekid.com/arma-scripting-tutorials-uav-r2t-and-pip/
*	
*	[player,attachmentPoint] execVM "CANYONRUN\functions\canyonRun_fnc_observerScreen.sqf";
*	
*/



/*

The way to switch between the streamed tv screen and fullscreen is to toggle between
canyonrun_var_camera cameraEffect ["internal", "BACK"];
and
canyonrun_var_camera cameraEffect ["internal", "BACK","stream"];

*/

// Do not run on dedicated servers
if (!hasInterface) exitWith {};




//---------------------------------------This is where we are at -----------------------------------------------
//---------------------------------------This is where we are at -----------------------------------------------

// So what's needed here?
// Everybody starts out watching the fixed spawn point from each clients stream
// As long as there is an aircraft going, I want to make sure each client get their stream on it
// Best way should be to make sure the function that starts each run also runs the camera update on every client



private _mode 				= _this select 0;	// Switches between spawn and aircraft observation
private _pilot 			= _this select 1;	// This is the camera target
private _attachmentPoint 	= _this select 2;	// This is a location relative to the target

//systemchat format ["observerScreen mode: %1",_mode];

// If the client running this script is the current pilot, don't run it
// It is possible that this will ruin the observation screen for a returning pilot though their screen never changed
//if (_pilot == player) exitWith {
	// Do nothing for now
	// But maybe the spawn point should just be the default?
	// Depends on future implementation of cameras along the canyon.
//};

// Do what's needed to get the camera onto the spawn point
if (_mode == "spawn") then {
	["observerScreen mode: spawn"] call canyonRun_fnc_debug;
	detach canyonRun_var_camera;
	canyonRun_var_camera camSetTarget canyonRun_var_spawnFlag;
	canyonRun_var_camera attachTo [canyonRun_var_spawnFlag,[20,15,10]];
	canyonRun_var_camera camCommit 0;
};


// If a run has just started, attach the camera onto the player or their aircraft
// There is a timing issue going on here. I'll have to spawn a delayed function.
// other players did not get their camera moved and attached to server player's aircraft
// The server player did get the right follow camera until it somtimes broke after many cycles
if (_mode == "runFlight") then {
	_pilot spawn {
	_pilot = _this;
	sleep 2;

	["observerScreen mode: runFlight"] call canyonRun_fnc_debug;
	detach canyonRun_var_camera;
	systemchat format ["runFlight using pilot: %1",_pilot];
	canyonRun_var_camera camSetTarget (vehicle _pilot);
	canyonRun_var_camera camSetRelPos [0,-50, 5];
	canyonRun_var_camera attachTo [vehicle _pilot,[0,-50, 5]];
	canyonRun_var_camera camCommit 0;
};
};





