/*
*	This function is responsible for maintaining the player queue
*
*	[_uid,true,false] call canyonRun_fnc_playerQuSeue; // Move player of this UID to first in queue
*	[_uid,false,true] call canyonRun_fnc_playerQueue; // Move player of this UID to last in queue
*
*/


private _playerUID		= _this select 0;	// player UID
private _input 			= _this select 1;	// BOOL

// The main usage of this function will be to take the first player in the list and move to the last position
// That will happen when a run is completed of failed

// The player list is called canyonRun_var_playerList
// The format of the list is: [_uid,_name,_selectedAircraft,_score]

// So first we find the player to reposition by finding their UID in the array
if (_input == "first") then {
		// Move to first position
		// Find out which element we want
		private _index = [canyonRun_var_playerList, _playerUID] call BIS_fnc_findNestedElement;
		_index = index select 0; // We just want the fist integer in that returned array

		_temp = _array select _index;// Store that in a temporary variable
		_array deleteAt _index; // delete the element from the array
		_array resize ( (count _array) + 1 );// expand the entire array by 1

		// move all the elements up by 1
		for "_i" from (count _array - 1) to 1 step -1 do {
			_array set [_i,_array select (_i - 1)];
		};

	

		// Finally set the first element as the temp variable
		_array set [0,_temp];

	}; // end of case

	if (_input == "last") then {
		systemchat "moving to last...";
		private _index = [canyonRun_var_playerList, _playerUID] call BIS_fnc_findNestedElement;
		_index = _index select 0;
		private _player = canyonRun_var_playerList select _index;
		canyonRun_var_playerList deleteAt _index;
		canyonRun_var_playerList pushBack _player;
		
	}; // end of case

// Push the updated array to all clients
publicVariable "canyonRun_var_playerList";