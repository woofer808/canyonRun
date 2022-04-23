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


_code = {hint "hello";sleep 1;hint "";};
{ 
  [] spawn _code;
 } remoteExec ["call", clientOwner];


------------------------------------------------------------------------------------ */


 private _target = _this select 0;	// UID of target client OR clientID integer
 private _code = _this select 1;		// Code passed to this function

// In the future, rewrite this so that this section just converts handy string input into clientID
if (typeName _target == "string") exitWith {
	systemchat "CANYONRUN: Can't remoteExec with a string target. Give clientID or UID.";
};

// If the function is passed a UID, find the target machine clientID of that UID
if (_target > 99) then {
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
{
	[] spawn _code;
} remoteExec ["call", _target]; // Confirmed to work just as well in SP (clientID == 0)
