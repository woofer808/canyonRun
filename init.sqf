
// Initialize the mission
[] execVM "CANYONRUN\canyonRun_core_init.sqf";



[] spawn { // This stops Niipaa's workshop from displaying a hint at startup
	sleep 1;
	hint "";
};
