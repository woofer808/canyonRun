/*
This runs code on the client machines

Maybe there should be code ON the client that can be remotely called by the server?
 */


/* NETWORKING NOTES ----------------------------------------------------------------

getPlayerUID returns  "_SP_PLAYER_" in single player

Network ID's
	- Server is always 2
	- First client is 3
	- 0 means everyone including JIP
	- 1 should not be used (current machine), use clientOwner instead


// Use this for testing
_code = {systemchat "This is proof of concept";sleep 1;hint "no this is"};
_target = 0; 
publicVariable "canyonRun_fnc_clientFunction";
sleep 1;
remoteExec ["canyonrun_fnc_compileall",_target]; 
sleep 1;
[_target,_code] call canyonRun_core_clientCode;

------------------------------------------------------------------------------------ */


private _target = _this select 0;		// UID of target client OR clientID integer
private _code = _this select 1;		// Code passed to this function

// In the future, rewrite this so that this section just converts handy string input into clientID
if (typeName _target == "string") exitWith {
	systemchat "CANYONRUN: Can't remoteExec with a string target. Give clientID or UID.";
};

// If the function is passed a UID, find the target machine clientID of that UID
if (_target > 999) then {
	_path = [canyonRun_var_playerList, _uid] call BIS_fnc_findNestedElement;
	_playerArray = canyonRun_var_playerList select path select 0; // Get the desired player array from the player list

	// Get the client network ID from the UID
	_uid = _playerArray select 0;
	_player = _uid call BIS_fnc_getUnitByUID;
	_clientID = owner _player;
	
	// Pass the converted UID on
	_target = _clientID;
};



// Pass a piece of code to the indicated target machine and spawn it there
//[_code] remoteExec ["call",_target]; // Confirmed working in player hosted MP but can't be suspended

// I can't seem to find a variation of remoteExec that can be suspended
// I want a way to push ANY code I want to a client
// Maybe I will have to compile and use the functions directly on each with remoteExec
// There has gotta be a way to be clever about it, right?
// Wait, what if we store the code in a var and push that before execuiting it?
canyonRun_fnc_clientFunction = _code;
// Apparently using 0 as target doesn't work with client version.
//Need an if statement to account for that
if (_target == 0) then {
	publicVariable "canyonRun_fnc_clientFunction";
} else {
	_target publicVariableClient "canyonRun_fnc_clientFunction";
};
remoteExec ["canyonRun_fnc_clientFunction",_target]; // Confirmed working in player hosted MP
