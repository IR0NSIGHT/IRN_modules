//calculates a random vector based on input
//upwards with a maximum 45° angle
params ["_length"];
private _v = [
	-1 + random 2, //-1 to 1
	-1 + random 2,
	0.7
];
_v = vectorNormalized _v;
_v = _v vectorMultiply _length; //scale to input length
diag_log ["rnd vector: ",_v,"vector magnitude", vectorMagnitude _v];
_v //return