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
	_selectedAircraft = "I_Plane_fighter_04_F";											// This aircraft is assigned by default
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

	_selectedAircraft = "I_Plane_fighter_04_F";					// This aircraft is assigned by default
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


