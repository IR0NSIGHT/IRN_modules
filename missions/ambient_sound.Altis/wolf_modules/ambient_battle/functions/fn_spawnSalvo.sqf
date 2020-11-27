/**
spawn x shots with tracers and delayed sound
runs local on client
*/
params["_sound","_pos","_shots","_delay","_distanceDelay","_volume","_pitch","_tracerVector","_tracerColor","_tracerPos"];
sleep _delay;
//diag_log ["################################# fnc_spawnsalvo called with: ",["_sound","_pos","_shots","_delay","_volume","_tracerVector","_tracerColor"],_this];
//systemChat ("shots spawned with delay: " + str _distanceDelay);
for "_i" from 0 to _shots do {
//	[_sound,_pos,_volume,_delay,_pitch] spawn IRN_fnc_delayedSound;
	[_tracerVector,_tracerColor,_tracerPos] call IRN_fnc_spawnTracer;
	sleep 0.1;
};
