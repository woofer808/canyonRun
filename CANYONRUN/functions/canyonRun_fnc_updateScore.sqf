
// Get the current pilot and make sure it's the one flying the plane
// If we get the first in the array someone might have edited that array after flight start

// So we either figure out a way to find the UID of the current pilot,
// or we store the current pilot UID in a variable at the start of the run

// Each time a pilot flies through a trigger area, a function to add a point will fire

// Format for a gate should be as simple as possible, so the trigger should do
// this call canyonRun_fnc_pointGate
// Which means each gate should pass the unit accessing them 


// I should be able to assume that if you are activating a point gate, then you are the one flying
// call canyonRun_fnc_pointGate


// Do we add the points directly to the array?
// There could be a risk to accessing and editing the array too often as client may overwrite eachother
// But there is no reason for the client to 
// So I guess not
// Still, I want to differentiate between current run points / Total or latest run points / high score

// What does our array look like?
// [_uid,_name,_selectedAircraft,_lastScore,_highScore]
//	  0   	1			2	   		  4		     5

// Maybe I should bring down the pilots array item and then send it back to the server when done
// and then the server can update the array accordingly




// Display current run points

// Check if last run got a higher score than the high score

// Store all time high score in profile?

/*




Hey guys!

Programming question.

I am maintaining a master array on the server that I want to maintain

```sqf
playerlist = [
    [_playerUID, _playerName, _someOther, _lastScore, _HighScore],
    [...],
    [...]
];```

Due to how Arma works I am counting points on the client that is currently flying.

What would be the best way to update the master array on the server? I see two main ways.

1: After a flight is done, update a global variable on client, broadcast it to the server which in turn updates the array?
2: Keep a function on the server which you can remoteExec from the client and pass the new score by params?


 */


private _pilotUID = _this select 0;	// The player that is to get the score
private _score = _this select 1;		// Recieves the new score from the client

// First we find the pilot in the array
_pilotArrayIndex = [canyonRun_var_playerList,_pilotUID] call BIS_fnc_findNestedElement;
_pilotArrayIndex = _pilotArrayIndex select 0;

// Now that we know which row to edit, update the correct value at that location
// Apparently you can't edit the cell you want immediately with an array as index:
// canyonRun_var_playerList set [[_pilotArrayIndex,3],_score];
// I suppose plucking it out and updating it will update the value in the main array  anyway
_pilotArray = (canyonRun_var_playerList select _pilotArrayIndex);

// Set last score
_pilotArray set [3,_score];

// Set high score if achieved
_hiScore =  _pilotArray select 4;
if ( _score > _hiScore ) then {
	_pilotArray set [4,_score];
	systemchat format ["new high score! %1 points",_score];
};

// Now we find out if the main array is updated.
// Yes, it's now updated

