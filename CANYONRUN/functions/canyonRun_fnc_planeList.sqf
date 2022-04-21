private _return = [];
private _aircraft = (typeOf (vehicle player));
switch (_aircraft) do {

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
	case ("I_Plane_fighter_03_dynamicLoadout_F"): {_return = // A-143 Buzzard (CAS)
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
		
	case ("I_Plane_fighter_04_F"): {_return = // A-149 Gryphon
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
	case ("C_Plane_Civil_01_F"): {_return = // Caesar BTT
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
		
	case ("C_Plane_Civil_01_Racing_F"): {_return = // Caesar BTT
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
		systemChat "Aircraft not supported, using default properties.";
	};
		
};




systemChat format ["returning %1",_return];
_return;
