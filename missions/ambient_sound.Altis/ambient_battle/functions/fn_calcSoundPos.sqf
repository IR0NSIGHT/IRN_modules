/**
this method calculates the desired position of the fake-createSoundSource
_player: specified player for which the sound source should be calculated. takes in any object with a position.
_center: origin where the battle is supposed to happen, position of module normally format posASL
_dist: distance offset from the player in meters where the fake soundsource will spawn. 400m is a good value for "distant" gunshots
_headPos: return value, position in posASL where the fake sound source should be.
*/
params ["_posP","_posC","_dist","_headPos"];
diag_log ["########## fnc calcSoundPos called with ",_this];

_direction = _posC vectorDiff _posP; //get desired positon of selfiestick headgear
//TODO add safeguard for players that manage to get very far away
if (vectorMagnitude _direction < _dist) then { //if center is closer than _dist, set pos directly at center
	_headPos = _posC;
} else { //else set in direction of center at _dist meters away
	_dirNorm = vectorNormalized _direction;
	_direction = _dirNorm vectorMultiply _dist;
	_headPos = _posP vectorAdd _direction;
};
_headPos