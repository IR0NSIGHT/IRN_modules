//spawn a delayed sound on this client
params ["_sound","_position","_volume","_delay"];
sleep _delay;
playSound3D [_sound, nil, false, _position, _volume, 1, 0];
