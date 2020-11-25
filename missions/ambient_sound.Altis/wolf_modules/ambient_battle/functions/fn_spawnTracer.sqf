params["_vector","_color","_pos"];
diag_log ["################################# fnc_spawnTracer called with: ",["_vector","_color"],_this];
private _lightpoint = "#lightpoint" createVehicleLocal _pos;
_pos = _pos vectorAdd [0,0,10];
_lightpoint setLightColor _color; // also defines Flare colour
_lightpoint setLightAmbient _color; // sets the colour applied to the surroundings
//_lightpoint setVelocity _vector;
_lightpoint setLightUseFlare true;
_lightpoint setLightFlareSize 2; // in meter
_lightpoint setLightBrightness 8;
_lightpoint setLightIntensity 4000;
_lightpoint setLightAttenuation [0, 2, 4, 4, 0, 9, 10]; // [start, constant, linear, quadratic, hardLimitStart, hardLimitEnd]
_lightpoint setLightDayLight true; // only for the light itself, not the flare

private _vessel = "B_408_Ball" createVehicleLocal _pos;
//hideObject _vessel;
_lightpoint lightAttachObject [_vessel,[0,0,0]];
_vessel setVelocity _vector;
//kill after 3 seconds
_handle = [3,_lightpoint,_vessel] spawn {
	params ["_time","_lightpoint","_vessel"];
	sleep _time;
	deleteVehicle _lightpoint;
	deleteVehicle _vessel;
}