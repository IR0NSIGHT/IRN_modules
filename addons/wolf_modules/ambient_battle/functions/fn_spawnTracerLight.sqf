//runs local on client
//fnc_spawnTracerLight
params ["_bullet","_color"];
private _lightpoint = "#lightpoint" createVehicleLocal [0,0,0];
_lightpoint lightAttachObject [_bullet,[0,0,0]];

_lightpoint setLightColor _color; // also defines Flare colour
_lightpoint setLightAmbient _color; // sets the colour applied to the surroundings

_lightpoint setLightUseFlare true;
_lightpoint setLightFlareSize 2; // in meter  2
_lightpoint setLightFlareMaxDistance 5000;

_lightpoint setLightBrightness 100; //how bright the flare itself is
_lightpoint setLightIntensity 50; //how strong the surroundings are lightened up
_lightpoint setLightAttenuation [0, 2, 4, 4, 0, 9, 10]; // [start, constant, linear, quadratic, hardLimitStart, hardLimitEnd]
_lightpoint setLightDayLight true; // only for the light itself, not the flare

//[["created tracer light for player",player,"with params",_this]] remoteExec ["diag_log",2];

//[str ["created tracer light for player",player,"with params",_this]] remoteExec ["systemchat",0];

//TODO
//add performant light killswitch on bullet despawn - eventhandler?
private _parameters = [4,_lightpoint,_bullet];
_parameters spawn {
	params ["_time","_lightpoint","_bullet"];
	_start = time;
	waitUntil {
		sleep 0.1;
		((time - _start > _time )|| isNull _bullet)
	};
	deleteVehicle _lightpoint;
}

