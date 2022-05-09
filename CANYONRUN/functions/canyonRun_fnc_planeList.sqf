/*


This function takes input of aircraft classname, finds it in the list and then returns corresponding attributes.

The array of aircraft define what classnames are supported by having tuned fuel leak properties.

This should probably be set up so that the array only loads once locally on the server.
For now I'll keep it this way to make testing easier. 

The list of aircraft name strings is broadcast by the server in init at the moment.  


*/

private _return = [];								// Declaration, not needed really I think
private _aircraftType = _this select 0; 	// Find out the classname of the aircraft


_planeList = 
[
	/*	Vanilla Blufor	*/
	[
		"B_Plane_CAS_01_dynamicLoadout_F", // A-164 Wipeout (CAS)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],

	[
		"B_Plane_Fighter_01_F", // Black Wasp II
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],

	[
		"B_Plane_Fighter_01_Stealth_F", // Black Wasp II (Stealth)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],
		
		
	/*	Vanilla Opfor	*/
	[
		"O_Plane_CAS_02_dynamicLoadout_F", // TO-199 Neophron (CAS)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],
		
	[
		"O_Plane_Fighter_02_F", // Shikra
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],
		
	[
		"O_Plane_Fighter_02_Stealth_F", // TO-201 Shikra (Stealth)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],
		
		
	/*	Vanilla Independent	*/
	[
		"I_Plane_Fighter_03_dynamicLoadout_F", // A-143 Buzzard (CAS)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],
		
	[
		"I_Plane_Fighter_04_F", // A-149 Gryphon
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],
		
	/*	Vanilla Civilian	*/
	[
		"C_Plane_Civil_01_F", // Caesar BTT
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	],
		
	[
		"C_Plane_Civil_01_racing_F", // Caesar BTT
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
	]
		
]; // End of plane list array

// Find the first index digit of the row containing the string name
private _find = _planeList findIf {_aircraftType == (_x select 0)};

// Account for cases where the input string didn't exist in the list
// Currently returning -1 but maybe should return default properties
if (_find == -1) then {

	["No aircraft match found in planeList, returning -1"] call canyonRun_fnc_debug;

	_return = -1;

} else {

	// Pull the fuel attribute array
	_return = (_planeList select _find) select 1;
	
};

// Return it to the outside world
_return;
