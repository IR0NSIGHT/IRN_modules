//calculates a random vector based on input
//upwards with a min 15° and maximum 45° angle
params ["_length"];
private _v = [
	-1 + random 2, //-1 to 1
	-1 + random 2,
	0
];
_v = vectorNormalized _v;
_v = _v vectorAdd [0,0,0.1 + random 0.4]; 
_v = vectorNormalized _v;
_v = _v vectorMultiply _length; //scale to input length
//diag_log ["rnd vector: ",_v,"vector magnitude", vectorMagnitude _v];
_v //return