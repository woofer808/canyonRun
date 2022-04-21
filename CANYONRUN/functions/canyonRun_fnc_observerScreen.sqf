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
private _target 			= _this select 1;	// This is the target player
private _attachmentPoint 	= _this select 2;	// This is where the camera is attached to


if (_mode == "spawn") exitWith {
	// Do what's needed to get the camera onto the spawn point

	detach canyonRun_var_camera;
	canyonRun_var_camera attachTo [canyonRun_var_spawnFlag,[20,15,10]];
	canyonRun_var_camera camSetTarget canyonRun_var_spawnFlag;
	canyonRun_var_camera camCommit 0;
} else {

};




