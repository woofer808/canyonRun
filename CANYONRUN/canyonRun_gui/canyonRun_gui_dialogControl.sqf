
// This script is spawned as the dialog is started
// Wait until the dialog has been created before attempting to write to it
waitUntil {dialog};




// Upon opening of gui, let the control show the current selected value
private _debugControl = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_guiDebugCheckbox; // Define the displaycontrol
if (canyonRun_var_guiDebugCheckboxState or canyonRun_var_debug) then {
	// Set the checkbox to checked
	_debugControl cbSetChecked true; // Set the stored value
} else {
	// Set the checkbox to unchecked
	_debugControl cbSetChecked false; // Set the stored value
};


// This will fire when the checkbox eventhandler in dialogs is triggered by clicking the checkbox
canyonRun_fnc_guiDebug = {
	private _debugControl = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_guiDebugCheckbox; // Define the displaycontrol
	private _checkedDebug = cbChecked _debugControl; // Checks state of checkbox
	if (_checkedDebug) then {
		canyonRun_var_debug = true;
		systemChat "Debug mode enabled";
	} else {
		canyonRun_var_debug = false;
	};

};








/* ----------------------------------------------------------------------------------------------------
									Player selection list
   ---------------------------------------------------------------------------------------------------- */
// Reset the player array
canyonRun_var_guiPlayerListArray = [];

// This will generate a list with live players excluding headless clients, but not the cameraman
private _allHCs = entities "HeadlessClient_F";
canyonRun_var_guiPlayerListArray = allPlayers - _allHCs;


// Define the displaycontrol
private _playerSelectionList = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_guiPilotList;

// Populate the dialog control with the list to generate proper indexes.
private _selectedIndex = 0;
private _playerName = 0;
{
	// Show the short name of the player in the list
	private _playerName = name _x;
	_playerSelectionList lbAdd _playerName;
} forEach canyonRun_var_guiPlayerListArray;







// This function is called by the eventhandler for the listbox in dialogs
canyonRun_fnc_guiPlayerList = {
	// Find out what was just selected in the list
	_selectedIndex = lbCurSel canyonRun_id_guiPilotList; // lbCurSel returns -1 when nothing is selected
	// Store the corresponding player in in variable
	canyonRun_var_guiPlayerListSelectedPlayer = (canyonRun_var_guiPlayerListArray select _selectedIndex);
};

// This is called from the "actor" button at the player listbox
canyonRun_fnc_guiPlayerListButton = {
	// Set the selected player as the actor
	systemchat "This is where the actor got selected";


	// Set the next pilot based on what was last selected in the list
	_uid = getPlayerUID canyonRun_var_guiPlayerListSelectedPlayer;
	[_uid,"first"] call canyonRun_fnc_playerQueue;


	// Update the text display naming the current actor
	private _currentPilotDisplay = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_nextPilotDisplay; // Define the displaycontrol
	_currentPilotDisplay ctrlSetText format ['Next pilot: %1', name canyonRun_var_guiPlayerListSelectedPlayer];

};


/*

// If the actor is any of the selected players in the list, then select that player (otherwise, select none?)
_checkArray = player in canyonRun_var_guiPlayerListArray;
if (_checkArray) then {
		_index = canyonRun_var_guiPlayerListArray find player;
		_playerSelectionList lbSetCurSel _index;
} else {
	// Actor is not in array. Don't select anyone, or select the topmost unit.
};

*/














// Populates the aircraft list
private _aircraftSelection = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_selectAircraft; // Define the displaycontrol
{
	_aircraftSelection lbAdd (_x select 1);
} forEach canyonRun_var_aircraftList;

// need the index of the currently selected aircraft
// first we find the index based on what is currently in playerlist
private _uid = getPlayerUID player;
// Get the path to the current player
private _playerPath = [canyonRun_var_playerList,_uid] call BIS_fnc_findNestedElement;
// Make a path to the element containing the aircraft class name
private _aircraftPath = [(_playerPath select 0), 2];
private _presetAircraft = [canyonRun_var_playerList,_aircraftPath] call BIS_fnc_returnNestedElement;
// Now I know what aircraft is currently in this player's array, let's find its index in aircraftList
private _aircraftIndex = [canyonRun_var_aircraftList,_presetAircraft] call BIS_fnc_findNestedElement;
// Now we know the path to the selection so we'll just use the first number
private _selectedIndex = (_aircraftIndex select 0);

// After loading gui, set the dropdown to its current value
lbSetCurSel [canyonRun_id_selectAircraft, _selectedIndex];




canyonRun_fnc_setAircraft = {
	// Find the control
	private _setAircraft = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_selectAircraft;
	// Find the index of the just selected aircraft
	private _selectedAircraft = lbCurSel _setAircraft;	// Checks state of drop-down
	canyonRun_var_aircraft = (canyonRun_var_aircraftList select _selectedAircraft) select 0;

	// Set the chosen aircraft classname in the playerList of the current player
	// Get the current player UID to sort the correct player out from playerList
	private _uid = getPlayerUID player;
	// Get the path to the current player
	private _playerPath = [canyonRun_var_playerList,_uid] call BIS_fnc_findNestedElement;
	// Make a path to the element containing the aircraft class name
	private _aircraftPath = [(_playerPath select 0), 2];

	// Finally set the correct value based on the new path
	[canyonRun_var_playerList, _aircraftPath, canyonRun_var_aircraft] call BIS_fnc_setNestedElement;

	[_uid,"planeSelection",canyonRun_var_aircraft] remoteExec ["canyonRun_fnc_updatePlayerList",2];
	{systemchat format ["sending you %1",canyonRun_var_aircraft];} remoteExec ["call",2];

};





// Update the text showing who the next pilot will be
private _currentPilotDisplay = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_nextPilotDisplay; // Define the displaycontrol
private _pilotName = [canyonRun_var_playerList, [0,1]] call BIS_fnc_returnNestedElement;
_currentPilotDisplay ctrlSetText format ['Next pilot: %1', _pilotName];




