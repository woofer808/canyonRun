// This is where we want to do a calculation

/* 

testScript = compile preprocessFileLineNumbers "CANYONRUN\test.sqf";

_time = time;
_handle = [] execVM "CANYONRUN\test.sqf";
waituntil {scriptDone _handle};


systemchat str "hello";
call testScript;

Calculation raw takes time: 0.706215 ms

calling the compiled code takes: 0.70922 ms 

ExecVM takes time: 

*/

for "_i" from 0 to 1000 step 1 do {

	_calc = _i*(cos (_i));
	_calc = sqrt (_calc^2)
};