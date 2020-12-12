/**
made by IRONSIGHT
Guardtower script

unit will rotate every couple seconds looking at a random position between 45° and 270° degrees from current direction
unit will be added a binocular and use it for searching the area
script is suspended if unit is in combat mode for 60 seconds

run the following code in the initfield of the guard unit.
 */

_handle = this spawn {
	params ["_myBoy"];
	_i = 0;
	_myBoy addWeapon "Binocular";
	while {alive _myBoy} do {
		if (behaviour _myBoy != "COMBAT") then {
			_i = _i + 1;
			_rnd = 45 + 225 * random 1;
			systemChat str _rnd;
			_myBoy doWatch (_myBoy getRelPos [500,_rnd]);
			_myBoy selectWeapon "Binocular";
		} else {
			sleep 60;
		};
		sleep (5 + random 5);
	};
}

