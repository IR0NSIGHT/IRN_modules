/**
spawn x shots with tracers and delayed sound
runs local on client
*/
params["_sound","_shots","_fireRate","_delay","_tracerVector","_tracerColor","_tracerPos","_flak"];
sleep _delay;
diag_log ["################################# fnc_spawnsalvo called with: ",["_sound","_pos","_shots","_delay","_volume","_tracerVector","_tracerColor"],_this];
private ["_everyX","_rndVec","_rndChance","_timeFired"];
_everyX = _flak select 0; //
_rndVec = _flak select 1; //false
_rndChance = _flak select 2; //0
_timeFired = time;
//spawn a bunch of bullets global, attach lights to it on each client
for "_i" from 0 to _shots do {
	private _chance = (_rndChance == 1 || _rndChance >= random 1);
	if (_chance || (_chance && _i mod _everyX == 0)) then { //spawn a tracer if chance = 100 or random chance true or every x tracer true
		if (_rndVec) then {
			//get a random angle
			_tracerVector = [vectorMagnitude _tracerVector] call IRN_fnc_randomVector;
		//	systemChat "rnd vec";
		};
		[_tracerVector,_tracerColor,_tracerPos] call IRN_fnc_spawnTracer;
	};
	sleep _fireRate;
};

//---------------------------------------------------------------------------------Loop until soundwave reached every player
_loop = true;
private ["_distS","_distP","_handledP"];

//list of players that already had the sound played
_handledP = [];
//systemChat "tracers";
while {_loop} do {
	//calculate how sound has travelled rn


	//sound distance made
	_distS = 333 * (time - _timeFired); //v*t = s 

	//breakout condition if all players are handeled
	if (_handledP isEqualTo allPlayers || _distS >= 5000) exitWith {
	};

	//check every player
	{	
		if (!(_x in _handledP)) then {
			//distance player to source
			_distP = _x distance _tracerPos;
			if (_distS >= _distP) then { //soundwave has reached player

				//players computers ID for network
				_id = owner _x;

				//players local soundsource position
				_position = [getPos _x, _tracerPos, 100] call IRN_fnc_calcSoundPos;
				
				//volume dependeing on distance to global soundsource
				_volume = 1 min ( 0.5 max (1 - ([_distP,800,4000,true] call IRN_fnc_interpolate)));
				
				//pitch depending on distance to global soundsource
				_pitch = 0.6 max _volume;

				//remotely play salvo of sounds on players machine
				[_sound,_position,_volume,_pitch,_shots,_fireRate] remoteExec ["IRN_fnc_remoteSalvo",_id];

				//TODO 
				//debug message
				systemChat str ["player ",name _x," heard shots at p-distance: ",_distP,"sound distance: ",_distS," after ",time - _timeFired," seconds with vol, pitch",_volume,_pitch];

				//remove from list
				_handledP pushBack _x;
			}
		}
	} forEach allPlayers;
//	systemChat str ["handled: ",_handledP," of ",allPlayers];
	sleep 0.5;
};
systemChat "audioLoop done";
