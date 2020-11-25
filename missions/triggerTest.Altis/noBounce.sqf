_plane = _this;
//EH for contact with ground
//EH for hit or Killed
_plane addEventHandler ["EpeContactStart", {	//fires only if collision is on land. water is not recognized.
	params ["_object1", "_object2", "_selection1", "_selection2", "_force"];
	systemChat format["plane made collision with %2, force %3 at time %1",round time,_object2,_force];
	_atl = round ((getPosATL _object1) select 2);

	if (_atl < 10 && !(alive _object1)) then {
		systemChat format ["ground collsion at %1m",_atl];
		//plane is dead and collding with something at lower than 10m above ground -> ground collision is likely.
		_pos = getPos _object1;
		_vector = velocity _object1; _object1 setVelocity [0,0,0];
		[_object1, false] remoteExec ["enableSimulationGlobal", 2];
		//_object1 setVelocity _vector;
		_pierce = {
			params ["_plane","_vector"]; _condition = false;
			hint "pierce running"; _wayTraveled = 0;
			waitUntil {

				_pos = getPos _plane; _time = 0.02;	//30fps
				_shortV = []; {
					_shortV pushBack (_x * _time);
				} foreach _Vector; //shorten Vector 
				_magn = vectorMagnitude _shortV; _wayTraveled = _wayTraveled + _magn; systemChat format ["magn Vectors is %1, wayTr is %2",_magn,_wayTraveled];
				_newPos = _pos vectorAdd _shortV;
				_plane setPos _newPos;
				_atl = ((getPosATL _plane) select 2);
				if (_atl <= 2 OR _wayTraveled > 5) then {
					_condition = true;
				};
				sleep _time;
				_condition
			};
			_plane setVelocity [0,0,0];
		};
		//[_object1,_vector] spawn _pierce;
		//hint str _thisEventHandler;
		_newPos = [_pos select 0,_pos select 1,0];
		_object1 setPosATL _newPos;
		_crater = "CraterLong" createVehicle _newPos;
		_crater setPos _newPos;
		_crater setDir getDir _object1;
		_object1 removeEventHandler ["EpeContactStart", _thisEventHandler];
		//project velocity forwards from plane center until ground is hit, tp plane there -> half buried

		//_posNew = [_pos select 0,_pos select 1,0];
		//_object1 setPosATL _posNew;
	};
}];
