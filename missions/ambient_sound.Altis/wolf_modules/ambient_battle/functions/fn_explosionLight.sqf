params["_pos","_color","_intensity"];
diag_log ["################################# fnc_explosionLight called with: ",["_pos","_color","_size","_brightness"],_this];
private _lightpoint = "#lightpoint" createVehicleLocal _pos;
_pos = _pos vectorAdd [0,0,2];

_lightpoint setLightAmbient _color; // sets the colour applied to the surroundings

_lightpoint setLightIntensity _intensity;
_lightpoint setLightAttenuation [0, 2, 4, 4, 0, 9, 10]; // [start, constant, linear, quadratic, hardLimitStart, hardLimitEnd]
_lightpoint setLightDayLight true; // only for the light itself, not the flare

//kill after 3 seconds
_handle = [0.05 + random 0.05,_lightpoint] spawn {
	params ["_time","_lightpoint"];
	sleep _time;
	deleteVehicle _lightpoint;
}
