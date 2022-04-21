
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

	systemChat str _selectedPilot;
	systemChat str canyonRun_var_pilot select _selectedPilot;
};









// Populates the aircraft list
private _aircraftSelection = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_selectAircraft; // Define the displaycontrol
{
	_aircraftSelection lbAdd (_x select 0);
} forEach canyonRun_var_aircraftList;

// After loading gui, set the dropdown to its current value
lbSetCurSel [canyonRun_id_selectAircraft, 0];




canyonRun_fnc_setAircraft = {
	// Find the control
	private _setAircraft = (findDisplay canyonRun_id_guiDialogMain) displayCtrl canyonRun_id_selectAircraft;
	private _selectedAircraft = lbCurSel _setAircraft;	// Checks state of drop-down
	canyonRun_var_aircraft = (canyonRun_var_aircraftList select _selectedAircraft) select 1;
};
