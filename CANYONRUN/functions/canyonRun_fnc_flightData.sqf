/*

------------------------------------------------------------------------------------------
[] spawn canyonRun_fnc_flightData;
------------------------------------------------------------------------------------------

It will stream flight data of the current pilot on screen so that those who do not fly can
follow along with what is going on better.

Runs locally on the current pilot machine. Streams data over network pretty heavily since
getting fuel levels and points from an aircraft owned by another machine is spotty at best.

It uses formatting from canyonRun_gui\canyonRun_gui_flightData.hpp

Params: _unit
Returns: nothing

------------------------------------------------------------------------------------------


Code is stolen (with blessings) from Regg's Killchain and then adapted to this:
// A counter in cutRsc
GENERAL_MESSAGE = true;
var_counter = 0;
while {var_counter < 100} do {

	var_counter = var_counter + 1;
	_text = format ["this is my text %1 <br/> next line",var_counter];

	disableSerialization;
	700 cutRsc ["GENERAL_MESSAGE", "PLAIN"];
	waitUntil {!isNull (uiNameSpace getVariable "GENERAL_MESSAGE")};
	_displayOBJUNITS = uiNameSpace getVariable "GENERAL_MESSAGE";
	_setText = _displayOBJUNITS displayCtrl canyonRun_id_flightDataStream;
	_setText ctrlSetStructuredText parseText (_text);
	_setText ctrlSetBackgroundColor [0,0,0,0.5];
	
	sleep 0.1;
};

*/

params ["_unit"];


canyonRun_fnc_flightDataStream = {

	params ["_text"];


	disableSerialization;
	700 cutRsc ["FLIGHTDATA_MESSAGE", "PLAIN"];
	_displayOBJUNITS = uiNameSpace getVariable "FLIGHTDATA_MESSAGE";
	_setText = _displayOBJUNITS displayCtrl canyonRun_id_flightDataStream;
	_setText ctrlSetStructuredText parseText (_text);
	_setText ctrlSetBackgroundColor [0,0,0,0.5];

};
publicVariable "canyonRun_fnc_flightDataStream";

private _name = name _unit;

while {canyonRun_var_activeRun} do {

	private _fuel = (fuel (vehicle _unit)) * 100;
	_fuel = [_fuel, 0] call BIS_fnc_cutDecimals;

	private _throttle = 100 * (airplaneThrottle (vehicle _unit));
	_throttle = [_throttle, 0] call BIS_fnc_cutDecimals;


	private _speed = speed (vehicle _unit);
	_speed = [_speed, 0] call BIS_fnc_cutDecimals;

	private _elevation = (getPosATL vehicle _unit) select 2;
	_elevation = [_elevation, 0] call BIS_fnc_cutDecimals;


	_text = format ["
		Pilot: %1<br/>
		Score: %2<br/>
		Remaining fuel: %3<br/>
		Throttle: %4<br/>
		Airspeed: %5<br/>
		Elevation: %6
		",
		_name,
		canyonRun_var_runScore,
		_fuel,
		_throttle,
		_speed,
		_elevation
	];

// Update the flight data display on other pilot's screens
 [_text] remoteExec ["canyonRun_fnc_flightDataStream",-clientOwner];

sleep 0.3;


};