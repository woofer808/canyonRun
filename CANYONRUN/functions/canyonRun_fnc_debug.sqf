
// Retreive any passed message
// Has to be in the form of an array as in
// ["hello world"] call canyonRun_fnc_debug
_message = _this select 0;

// Put the message in the log for possible future reference
diag_log format ["canyonRun DEBUG --> %1: %2", time ,_message];

// If debug mode is on, display it in systemchat
if canyonRun_var_debug then {
	
	systemChat format ["canyonRun DEBUG --> %1: %2", time ,_message];

};
