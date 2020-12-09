//spawn a delayed sound on this client
params ["_sound","_position","_volume","_delay","_pitch"];
sleep _delay;

playSound3D [_sound, objNull, false, _position, _volume, _pitch, 0];

