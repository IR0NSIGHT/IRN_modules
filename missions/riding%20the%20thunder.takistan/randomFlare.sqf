//this execVM "randomFlare.sqf";
if (!isServer) exitWith {};
_center = getPos _this;
while {!(missionNamespace getVariable ["endFlare",false])} do {
	endFlare = missionNamespace getVariable ["endFlare",false];
	//get all enemies
	_list = _center nearEntities 1000;
	//_list = _list select {side _x == east};
	//pick some of them
	_oldEnemy = objNull;
	_enemy = objNull;
	for "_h" from 0 to 2 do {
		if (_h > 0) then {
			_list = _list select {(_x distance _oldEnemy) > 200};	//remove enemy from array to not get double positions
		};
		
		if (count _list > 0) then {
			_enemy = selectRandom _list;
			for "_i" from 0 to (3 + round random 5) do {
				_enemy spawn { //spawn flare at their pos
					sleep random 10;
					_class = selectRandom ["F_40mm_White"];
					_flare = _class createvehicle ((_this) ModelToWorld [random [-100,0,100],random [-100,0,100],100 + random 100]); 
					_flare setVelocity [0,0,random [-8,-6,-4]];
					hint _class;
				};
			};

		};
	_oldEnemy = _enemy;
	};
	sleep Random 60;
};
missionNamespace setVariable ["endFlare",false,true];
hint "flares beendet";