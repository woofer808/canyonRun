/*
*
*		CANYON RUN
*
*/






// Control buttons
canyonRun_fnc_guiStart = {};

// Debug
canyonRun_fnc_guiDebug = {};
canyonRun_var_guiDebugCheckboxState = false;






/*
ID's
These numbers has to match what's defined in canyonRun_gui_dialogs.hpp
*/
canyonRun_id_guiDialogMain = 909;
canyonRun_id_guiDebugCheckbox = 910;
canyonRun_id_selectPilot = 911;
canyonRun_id_selectAircraft = 912;



/*
functions
The GUI outputs the following controls to be used in the main canyonRun script.
*/

canyonRun_gui_dialogControl = compile preprocessFileLineNumbers "CANYONRUN\canyonRun_gui\canyonRun_gui_dialogControl.sqf";



