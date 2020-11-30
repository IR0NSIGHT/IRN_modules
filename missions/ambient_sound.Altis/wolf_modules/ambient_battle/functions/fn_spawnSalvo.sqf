/**
spawn x shots with tracers and delayed sound
runs local on client
*/
params["_sound","_shots","_fireRate","_delay","_tracerVector","_tracerColor","_tracerPos","_flak"];
sleep _delay;
diag_log ["################################# fnc_spawnsalvo called with: ",["_sound","_pos","_shots","_delay","_volume","_tracerVector","_tracerColor"],_this];
private ["_everyX","_rndVec","_rndChance","_timeFired"];
_everyX = _flak select 0;
_rndVec = _flak select 1;
_rndChance = _flak select 2;
_timeFired = time;
//spawn a bunch of bullets global, attach lights to it on each client
for "_i" from 0 to _shots do {
	if (_rndChance == 1 || _rndChance <= random 1 || _i mod _everyX == 0) then { //spawn a tracer if chance = 100 or random chance true or every x tracer true
		if (_rndVec) then {
			//get a random angle
			_tracerVector = [vectorMagnitude _tracerVector] call IRN_fnc_randomVector;
			systemChat "rnd vec";
		};
		[_tracerVector,_tracerColor,_tracerPos] call IRN_fnc_spawnTracer;
	};
	sleep _fireRate;
};
_loop = true;
private ["_distanceTravelled"];
while {_loop} do {
	//calculate how sound has travelled rn
	_distanceTravelled = 333 * (time - _timeFired); //v*t = s
	//check every player
	{
		_dist = _x distance _tracerPos;
		if (_dist <)
	} forEach allPlayers;
}
