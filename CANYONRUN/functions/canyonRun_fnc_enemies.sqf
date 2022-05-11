

/*

To strip a zsu-39 tigris of AA missiles:
---------------------------------------
this removeMagazinesTurret ["4Rnd_Titan_long_missiles_O",[0]];

Fire at a designated aircraft
-----------------------------
Confirmed working with AA turret
sourceVehicle fireAtTarget [targetVehicle, weaponMuzzleName]
aa fireAtTarget [helo]





_groupLeaders = allUnits select {side _x == west};
systemchat str _groupLeaders;

canyonRun_var_enemyArray = [];

{ 
	_type = typeOf vehicle _x; 
	_pos = getPos _x; 
	_dir = getDir _x; 

	_arrayElement = [_type, _pos, _dir]; 
	canyonRun_var_enemyArray pushBack _arrayElement;

	systemchat str _arrayElement; 


} forEach _groupLeaders;

hintSilent str canyonRun_var_enemyArray;


_groupLeaders = (allUnits - allPlayers) select {side _x == east};
{{deleteVehicle _x} forEach crew _x + [vehicle _x]} forEach _groupLeaders;


sleep 2;

{ 
  
_unit = (_x select 0);
_pos = (_x select 1);
_dir = (_x select 2);

systemchat str [_unit,_pos];

_veh = createVehicle [_unit, _pos, [], 0, "NONE"];
_veh setDir _dir;
createVehicleCrew _veh;

} forEach canyonRun_var_enemyArray; 
 






*/






// For replayability, I'm gonna need a way to place and reset enemies for each run.
// Maybe place everything in the editor and record enemy type, position and direction at mission start
// Yeah, let's try that

// So, there are currently two different types of enemies on the terrain
//	- AA tigris guns that fire on visibility

//	- AA launcher teams that fire through triggers

// First we put all editor placed enemy units into an array

canyonRun_var_enemyArray = [];    
 
_units = []; 
{_units pushBack (leader _x)} forEach allGroups; 
 
_groupLeaders = _units select {side _x == east && (!isPlayer _x)}; 





// Go through the enemy array and record the data
{ 
	_type = typeOf vehicle _x; 
	_pos = getPos _x; 
	_dir = getDir _x; 

	_arrayElement = [_type, _pos, _dir]; 
	canyonRun_var_enemyArray pushBack _arrayElement;


} forEach _groupLeaders;


// Then we need a function to turn them on on demand
canyonRun_fnc_enemyStart = 	{

	{
		_unit = (_x select 0);
		_pos = (_x select 1);
		_dir = (_x select 2);

		_veh = createVehicle [_unit, _pos, [], 0, "NONE"];
		_veh setPos _pos;
		_veh setDir _dir;
		createVehicleCrew _veh;

		// Strip AA vics of rockets
		_veh removeMagazinesTurret ["4Rnd_Titan_long_missiles_O",[0]];

	} forEach canyonRun_var_enemyArray;
	
	["Enemy forces reset"] call canyonRun_fnc_debug; 

};

// And a function for turning them off
canyonRun_fnc_enemyStop = 	{
	_groupLeaders = (allUnits - allPlayers) select {side _x == east};
	
	{{deleteVehicle _x} forEach crew _x + [vehicle _x]} forEach _groupLeaders;

	["Enemy forces removed"] call canyonRun_fnc_debug; 
};


[] call canyonRun_fnc_enemyStop;
