//this execVM "pilot.sqf";
//add fired eventhandler to pilot / plane
_planes = missionNamespace getVariable ["planes",[]];	//get all planes
_planes pushBack _this;
{
	_x addEventHandler ["Fired", 
		{
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
			[_projectile] spawn {
				params ["_projectile"];
				if (isNull _projectile) exitWith {}; 
				_pos = [0,0,0];
				_type = typeOf _projectile;
				_launchTime = round time;
				waitUntil {
					_posX = getPos _projectile;
					if !(_posX isEqualTo [0,0,0]) then {
						_pos = _posX;
					};
					_posATL = ((getPosATL _projectile) select 2);
					sleep 0.02;
					_flightTime = time -_launchTime;
					(isNull _projectile OR _posATL < 5 OR _flightTime > 45)	//prevents bullets that fly -just over the hilltop- from being counted and strays that just flyacross the map. 
				};
				
				if !(_pos isEqualTo [0,0,0]) then {
					_impacts = missionNamespace getVariable ["impacts",[]];
					_impacts pushBack [_pos,round time];
					missionNamespace setVariable ["impacts",_impacts,true];
				}; 
				//systemChat format ["impact at %1 with %2",_pos,_type];
				//systemChat format ["distance to plane: %1",_pos distance getPos player];
				"VR_3DSelector_01_default_F" createVehicle _pos;	
			}; 
		} //code fired EH
	];// -- fired EH end
} foreach _planes;


_lastTimeShot = 0; _noShotTime = 5; //time to go by without an impact to end this volley
_distAll = 0;
_i = 0;
_hits = 0; _off = [];
_numberToRadio = {
	sleep 0.1;
	params ["_number",["_message",[]],["_sound",""]];
	_numberArr = ( str (floor _number)) splitSTring ""; //100.7 -> "100"
	//systemChat str _numberArr;
	{
		_condition = _x;	//string consisitng of 1 letter: "1" f.e.
		//systemChat format ["cond x = ",_condition];
		switch (_condition) do {
			case "0":{	_sound =  "ot_zero"		};
			case "1":{	 _sound = "ot_one";		};
			case "2":{	 _sound = "ot_two";		};
			case "3":{	 _sound = "ot_three";		};
			case "4":{	 _sound = "ot_four";		};
			case "5":{	 _sound = "ot_five";		};
			case "6":{	 _sound = "ot_six";		};
			case "7":{	 _sound = "ot_seven";		};
			case "8":{	 _sound = "ot_eight";		};
			case "9":{	 _sound = "ot_nine";		};
			default {};
		};
		if !(_message isEqualTo "") then {
			_message pushBack _sound;
		};
	} foreach _numberArr;
	//systemChat str _message;
	_message
};
_radioMP = {
	params [["_message",[]]];
	hint str _message;// systemChat str _message;
	{
		[west, "Base"] sideRadio _x;
		sleep 0.1;
	} foreach _message;
};

_OffTargetRadio = {	//will generate radio call with give parameters (if supported).
	params ["_distance"];	//given in 7.5km format, only 500 m steps.
	_km = floor _distance;_pointFive = (_distance > _km); _message = ["ot_start"]; _sound = "";
	//put together the list of radio classnames to play
	_arr = _km call _numberToRadio;
	_message = _message + _arr;
	
	if (_pointFive) then {
		_message pushBack "ot_pointFive";
	};
	_message pushBack "ot_end";
	//-- message was created, play it via radio now
	//systemChat str _message;
	[_message] call _radioMP;
};
_HitTargetRadio = {	//will generate radio call with give parameters (if supported).
	params ["_distance","_direction","_hits",["_message",[]]];	//given in 7.5km format, only 500 m steps.
	if (_hits <= 0) then {	//miss close
		_message = ["miss_correct"];
		_message = _message + (_distance call _numberToRadio);
		_message pushBack "miss_distDir"; 
		_message = _message + (_direction call _numberToRadio);
	} else { //hit
		_message = [];
		_message = _message + (_hits call _numberToRadio);
		_message pushBack "hit_area";
	};
	[_message] call _radioMP;

	//-- message was created, play it via radio now

};
//["offTarget01start","offTarget02_seven","offTarget03_pointFive","offTarget04end"] call _OffTargetRadio;
//JAItac
while {true} do {

	_allowedRadius = 30;	//meters from target still considered Hit


	if (_i > 0 && ((_lastTimeShot  + _noShotTime) < round time)) then {	//give feedback, reset volley to zero
		_precision = _distAll / _i;
		_offLoc = _off;
		_offLoc sort false;

		_farMax = _offLoc select 0 select 1;
		//count shots that went way off
		_filtered1 = _offLoc select {((_x select 1) > 500)};
		systemChat format ["offLoc Arr has pos zero with: %1",_offLoc select 0];
		
		_num = count (_offLoc select {_x select 1 > 500});
		_total = count _offLoc;
		systemChat format ["volley of %1, missed %2",_total,_num];
		if (_num > (_total - _num)) then {	//check if moren than half the hits are way off target
			_farMax = (round (_farMax /500)) / 2;	//round to 500m, display in km
			//systemChat format ["what the hell are you engaging?! You are %1 km of target!",_farMax];
			[_farMax] call _OffTargetRadio;
		} else {	//not way off target
		params [["_dist",0],["_dir",0]];
			if (_hits <= 0) then {	//no hits
				//get closest, give feedback about hit
				_offLoc sort true;
				_clostest = _offLoc select 0;
				_clostestPos = _clostest select 0; _targetPos =(getMarkerPos ["marker_0", true]);
				_dist =( round ((_clostest select 1)/20)) * 20;
				_dir = (round ((_clostestPos getDir _targetPos)/10) )* 10;
				
				//systemChat format ["you are off target. Correct for %1 meters to %2",_clostestDist,_dirToTarget];

				//[west, "Base"] sideRadio "miss_correct";
			} else { //give hit number
				//systemChat format ["you got %1 hits",_hits];
				//[west, "Base"] sideRadio "hit_area";
			};
			[_dist,_dir,_hits] call _HitTargetRadio;
		};

		
		_distAll = 0;
		_i = 0; _hits = 0; _off = [];
	};
	//do all impacts available
	_impacts = missionNamespace getVariable ["impacts",[]];
	if (count _impacts > 0) then {

		//systemChat "splash down";
		
		{
			_hitPos = _x select 0;
			_time = _x select 1;
			if (_time > _lastTimeShot) then {	//update last time shot
				_lastTimeShot = _time;
			};
			_dist = (_hitPos distance (getMarkerPos ["marker_0", true]));	//get position of position hit to target
			if (_dist < 25) then {	//hit landed 10m or closer -> hit
				_hits = _hits + 1;
			} else {	//hit landed further than 10m from target -> miss
				_off pushBack [_hitPos,_dist];
			};
			_distAll = _distAll + _dist; _i = _i + 1;

			impacts deleteAt _foreachIndex;	//delete used impact for queue
		} foreach _impacts;		
	};
	sleep 1;
	//systemChat format ["last time shot %1, time till volley is over %2, time now %3",round _lastTimeShot,round (_lastTimeShot + _noShotTime),round time]
};



//create Killed/Hit EH for all units near fire mission target
//get all enemy units 20m radius marker