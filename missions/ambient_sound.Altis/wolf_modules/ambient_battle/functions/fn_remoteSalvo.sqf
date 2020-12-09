//play a salvo of sounds on this client
params ["_sound","_position","_volume","_pitch","_shots","_fireRate"];
//diag_log ["played remote salvo to",name player,"with params:",_this];
private _left = [
	_sound,
	objNull,
	false,
	_position,
	_volume,
	_pitch,
	0
];
for "_i" from 0 to _shots do {
	playSound3D _left;
	sleep _fireRate;
};

