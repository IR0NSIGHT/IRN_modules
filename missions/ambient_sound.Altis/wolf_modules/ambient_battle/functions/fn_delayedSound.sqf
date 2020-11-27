//spawn a delayed sound on this client
params ["_sound","_position","_volume","_delay","_pitch"];
//sleep _delay;

diag_log ["delayed sound was spawned with ",_this,"on machine ",name player," with distance to player: ", _position distance player];
waitUntil {
	sleep 0.5;
	_delay = _delay - 0.5;
	hint ("sound in " + str round (_delay * 10));
	(_delay <= 0);
};
hint "bang"; 
systemChat str ["volume: ", _volume];
systemChat str ["pitch: ", _pitch];
playSound3D [_sound, objNull, false, _position, _volume, _pitch, 0];

