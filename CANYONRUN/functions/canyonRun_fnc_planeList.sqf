/*

Can't make this switch work properly for some reason.
The switch _aircraftType seems to render right into "I_Plane_fighter_04_F"
So the input passed to the function and subsequent conversion to string works


This works:

systemchat str (typeof player);
_mySwitch = (typeof player);
switch (_mySwitch) do {
	case "asdf": {systemchat "asdf"};
	case ("B_Fighter_Pilot_F"): {systemchat "pilot"};
	default {systemchat "Default"}; 

};

IT WAS BECAUSE SWITCH IS CASE SENSITIVE

"I_Plane_Fighter_04_F" was "I_Plane_fighter_04_F"

*/




private _return = [];								// Declaration, not needed really I think
private _aircraftType = typeOf (_this select 0); 	// Find out the classname of the aircraft

switch _aircraftType do {

		default {_return = // The default values for when aircraft isn't supported
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		];
		systemChat "canyonRun: Aircraft not supported, using default fuel loss coefficient.";
	};

	/*	Vanilla Blufor	*/
	case ("B_Plane_CAS_01_dynamicLoadout_F"): {_return = // A-164 Wipeout (CAS)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};

	case ("B_Plane_Fighter_01_F"): {_return = // Black Wasp II
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};

	case ("B_Plane_Fighter_01_Stealth_F"): {_return = // Black Wasp II (Stealth)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		
		
	/*	Vanilla Opfor	*/
	case ("O_Plane_CAS_02_dynamicLoadout_F"): {_return = // TO-199 Neophron (CAS)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		
	case ("O_Plane_Fighter_02_F"): {_return = // Shikra
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		
	case ("O_Plane_Fighter_02_Stealth_F"): {_return = // TO-201 Shikra (Stealth)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		
		
	/*	Vanilla Independent	*/
	case ("I_Plane_Fighter_03_dynamicLoadout_F"): {_return = // A-143 Buzzard (CAS)
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		
	case ("I_Plane_Fighter_04_F"): {_return = // A-149 Gryphon
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		
	/*	Vanilla Civilian	*/
	case "C_Plane_Civil_01_F": {_return = // Caesar BTT
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		
	case ("C_Plane_Civil_01_racing_F"): {_return = // Caesar BTT
		[
		[95,0.025],		// Throttle percentage with fuel loss
		[70,0.020],		// Throttle percentage with fuel loss
		[55,0.010],		// Throttle percentage with fuel loss
		[45,0.005],		// Throttle percentage with fuel loss
		[35,0.0025],	// Throttle percentage with fuel loss
		[-0.1,0,0],		// Smoke pos 1
		[0.1,0,0]		// Smoke pos 2
		]
		};
		

		
}; // End of switch

_return;
