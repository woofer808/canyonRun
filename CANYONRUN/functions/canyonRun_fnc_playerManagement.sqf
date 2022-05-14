/*
* This is the server machines list of connected players and their preferred aircraft
* It keeps track of connecting and disconnecting players and hands the list to the game master
*
* Should only run on the server machine which broadcasts the necessary info
*
*/




// If you are not the server, do not run the code in here
if (!isServer) exitWith {
	["Connected as a player, not running server code"] call canyonRun_fnc_debug;
};

// The server should establish the global player list variable and broadcast it to JIP clients.
missionNamespace setVariable ["canyonRun_var_playerList", [], true];


// Populate the list for the first time but do not count headless clients
private _onlyPlayers = call BIS_fnc_listPlayers;
{
	_uid = getPlayerUID _x;																// Player UID as string to pinpoint a player
	_name = name _x;																	// The name as a string
	_selectedAircraft = "I_Plane_Fighter_04_F";											// This aircraft is assigned by default
	_score = 0;																			// Score of current/last run
	_highScore = 0;																		// The highest score achieved during a run
	canyonRun_var_playerList pushBack [_uid,_name,_selectedAircraft,_score,_highScore];	// Add to the list
} forEach _onlyPlayers;




// Now make it so that every joining or disconnecting player is added or removed from the list
// The plan is to do that with mission eventhandlers for connecting and disconnecting players
// The server should be the one keeping track of that and to update the list so that crashing players won't get left on
// Probably need to heed the fact that open drop-downs could still be populated with disconnected players that should say "player disconnected, find another one"





/*
This command will execute the provided code on the server whenever a player connects to a multiplayer session.

id: Number - unique DirectPlay ID (very large number). It is also the same id used for user placed markers (same as _id param)
uid: String - getPlayerUID of the joining client. The same as Steam ID (same as _uid param)
name: String - profileName of the joining client (same as _name param)
jip: Boolean - didJIP of the joining client (same as _jip param)
owner: Number - owner id of the joining client (same as _owner param)
idstr: String - same as id but in string format, so could be exactly compared to user marker ids
*/
addMissionEventHandler ["PlayerConnected",
{
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"]; // This comes from the eventhandler

	_selectedAircraft = "I_Plane_Fighter_04_F";					// This aircraft is assigned by default
	_score = 0;

	
	// I want to check that the connecting _uid isn't already on the list before adding it
	// BIS_fnc_findNestedElement returns path array to found object or an empty array if nothing is found
	_path = [canyonRun_var_playerList, _uid] call BIS_fnc_findNestedElement;
	// Check if nothing was found
	if (count _path == 0) then {
		// Put this connected player at the end of the player list
		canyonRun_var_playerList pushBack [_uid,_name,_selectedAircraft,_score];
	} else {
		["Found a duplicate connecting player, will not add to player list"] call canyonRun_fnc_debug;
	};

	// Push the updated variable to all clients
	publicVariable "canyonRun_var_playerList";

}]; // End of addMissionEventHandler



/*
This command will execute the provided code on the server whenever a player connects to a multiplayer session.

id: Number - unique DirectPlay ID (very large number). It is also the same id used for user placed markers (same as _id param)
uid: String - getPlayerUID of the leaving client. The same as Steam ID (same as _uid param)
name: String - profileName of the leaving client (same as _name param)
jip: Boolean - didJIP of the leaving client (same as _jip param)
owner: Number - owner id of the leaving client (same as _owner param)
idstr: String - same as id but in string format, so could be exactly compared to user marker ids
*/
addMissionEventHandler ["PlayerDisconnected",
{
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"]; // This comes from the eventhandler
	
	// Debug message on disconnecting player 
	[format ["Player %1 has left the game.",_name]] call canyonRun_fnc_debug;

	// Now to remove the disconnecting player from the list
	// First we find the perpetrator on the list
	_path = [canyonRun_var_playerList, _uid] call BIS_fnc_findNestedElement;

	// Now to use the supplied path and remove the player array of the disconnector
	canyonRun_var_playerList deleteAt (_path select 0);

	// Push the updated variable to all clients
	publicVariable "canyonRun_var_playerList";

}];



// This function receives data from a client and updates the playerList array locally on the server
// Do I specify data+address or should it be data type+data
// Let's have the client request a type of update and then what the client wants


/**
For testing what's below

[] call canyonRun_fnc_compileAll;
systemchat str canyonRun_var_playerList;
_uid = getplayeruid player;
_dataType = "planeSelection";
_data = "B_Plane_CAS_01_dynamicLoadout_F";
[_uid,_dataType,_data] call canyonRun_fnc_updatePlayerList;
systemchat str canyonRun_var_playerList;

 */

// To call it, use:
// [_clientUID,_dataType,_data] remoteExec ["canyonRun_fnc_updatePlayerList",2];
canyonRun_fnc_updatePlayerList = {

	private _uid = _this select 0;			// UID of the client requesting an update
	private _dataType = _this select 1;		// string: "planeSelection" and such
	private _data = _this select 2;			// The data sent over from the client


	// If the data type coming in is "planeSelection" then find the unit based on UID,
	// check the planeList for the selection
	// and finally update the playerList with the new aircraft class name
	if (_dataType == "planeSelection") then {

		// Need a test in here to make sure that the data sent worked in planeList
		// before trying to set it
		_aircraft = [_data] call canyonRun_fnc_planeList;
		
		if ((typeName _aircraft) != "ARRAY") exitWith {
			["Data selection failed: planeList returned -1"] call canyonRun_fnc_debug;
		};


		// First we find the path to the requesting client in playerList based on UID
		_path = [canyonRun_var_playerList, _uid] call BIS_fnc_findNestedElement;
		
		// Set the element directly by changing _path to match it's position in the client's array
		_path set [1,2]; // turns [0,1] to [0,2] in the case of player host in MP
		[canyonRun_var_playerList, _path,_data] call BIS_fnc_setNestedElement;

		// Distribute it over the network
		publicVariable "canyonRun_var_playerList";


		systemchat str canyonRun_var_playerList;
	};


};



/*
let's find out if we can tie game master to the top one slot
there are a few problems to solve though
	- check if ANYONE is occupying the game master slot dead or alive
	- check if a specific player is occupying the gamePL master slot
	- don't loose track if the slot is left empty or repopulated
seems like naming the unit is what is left to us. So maybe checking that p0 is alive?

This is the only working piece of shit code I have that can check for an possible
unexisting unit: if (isNil "p0") then {systemchat "weee"};

Gonna have to compound this I suppose
	- First check if p0 is even spawned in with isNil "p0"
	- Second, check if that unit is a player with isPlayer p0 to rule out possible AI
	- Within that, find out the UID of the player of p0

What if p0 has logged in and then disconnected or swapped slot? Now there should be an object 
defined called p0 that at least WAS a player. that has to be tested

There is also the question of how the game should work when there is no game master in that slot
Aaaah, but you see then of course everything just rolls along timed between runs.

Honestly - one player should have a shorter timer than multiple players, right?
*/

// I think I need a continuous way to check if the game master slot is occupied
// But until that need presents itself, for now I'll just do a function that can be run to check
// Maybe it's even better to check for players in the p0 slot at need, cause it wont' happen often
canyonRun_fnc_gameMasterCheck = {

	private _return = false;

	["Checking for game master..."] call canyonRun_fnc_debug;

	if (!isNil "p0") then {
		
		if (isPlayer p0) then {
		
		["p0 is a player that uses the first slot"] call canyonRun_fnc_debug;
		_return = true;

		};

	} else {

		["No player in p0 slot"] call canyonRun_fnc_debug;

		_return = false

	};

	_return;

};
