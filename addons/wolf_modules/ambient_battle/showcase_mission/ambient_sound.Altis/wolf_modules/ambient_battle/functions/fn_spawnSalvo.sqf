params["_sound","_pos","_shots","_delay","_volume","_tracerVector","_tracerColor","_tracerPos"];
diag_log ["################################# fnc_spawnsalvo called with: ",["_sound","_pos","_shots","_delay","_volume","_tracerVector","_tracerColor"],_this];
sleep _delay;
for "_i" from 0 to _shots do {
	playSound3D [_sound, nil, false, _pos, _volume, 0, 0]; // play sound
	[_tracerVector,_tracerColor,_tracerPos] call IRN_fnc_spawnTracer;
	sleep 0.1;
};
