
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







// Populates the player list
private _pilotSelection = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_selectPilot; // Define the displaycontrol
{
	_pilotSelection lbAdd ( _x select 1 );
} forEach canyonRun_var_playerList;

// After loading gui, set the dropdown to it's current value
lbSetCurSel [canyonRun_id_selectPilot, 0];

// find out what the current value of the drop-down is

canyonRun_fnc_setPilot = {
	// Find the control
	private _setPilot = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_selectPilot;
	private _selectedPilot = lbCurSel _setPilot;	// Checks state of drop-down
	canyonRun_var_pilot = canyonRun_var_playerList select _selectedPilot;

};









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
