//add fired eventhandler to pilot / plane
_planes = missionNamespace getVariable ["planes",[]];	//get all planes

{
	_x addEventHandler ["Fired", 
		{
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
			//systemChat format ["CAS plane has fired %1, object is %2, gunner is %3",_ammo,_projectile,_gunner];
			//systemChat format ["projectile is type %1",typeOf _projectile];
			//add destroyed EH for projectile -> hit sth
			[_projectile] spawn {
				params ["_projectile"];
				if (isNull _projectile) exitWith {}; 
				_pos = [0,0,0];
				_type = typeOf _projectile;
				waitUntil {
					//systemChat "-";

					_posX = getPos _projectile;
					if !(_posX isEqualTo [0,0,0]) then {
						_pos = _posX;
					};
					_posATL = ((getPosATL _projectile) select 2);
					//hint format ["meters above terrain: %1",_posATL];
					"Sign_Sphere200cm_F" createVehicle _pos;
					sleep 0.02;
					(isNull _projectile OR _posATL < 5)
				};
				/*
				if !(_pos isEqualTo [0,0,0]) then {
					missionNamespace getVariable ["impacts",[]];
					_impacts pushBack [_pos,round time];
					missionNamespace setVariable ["impacts",_impacts,true];
				}; */
				//systemChat format ["impact at %1 with %2",_pos,_type];
				//systemChat format ["distance to plane: %1",_pos distance getPos player];
				"VR_3DSelector_01_default_F" createVehicle _pos;	
			}; 
			_projectile addEventHandler ["EpeContactStart",
				{
					params ["_object1", "_object2", "_selection1", "_selection2", "_force"];
					systemChat "EH impact";
				} // code killed EH
			];//-- killed EH end
		} //code fired EH
	];// -- fired EH end
} foreach _planes;

//systemChat str getShotParents (_projectile); //gets projectiles origin vehicle and gunner
