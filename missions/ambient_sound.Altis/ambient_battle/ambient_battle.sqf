/*
made by IR0NSIGHT
a script which plays gunshots at 400m distance in the direction of a given center object.
creates illusion of nearby gunfight in the direction of the specified object, while allowing bigger distances than are possible with vanilla soundsimulation.

will only execute on the server machine and remotely execute sounds on all clients.
*/
//--------------------------------------------------------------------------------------------

//FIXME clean up variables
_action = "init";
diag_Log ["----------","IRN_ambient_battle with params",_this]; 

//TODO move input parameters here
params ["_minDistance","_maxDistance","_salvoFrequency","_salvoAverage","_expAverage","_endTime","_tracerEveryX","_tracerRndVec","_tracerColorPalette","_percentTracers","_expColorPalette","_expSize","_expSounds","_shotSounds","_debug","_center"];

//TODO check if sound has max hearing distance

if (!isServer || _action !="init") exitWith {}; //only executes ingame, not in Eden
//technical variables
private ["_i","_start","_end","_expPosGlobal","_expSound","_min"];

//---------------------create an object that holds all params
//TODO add public vars that can be changed during the mission
//create a variable holder object
_hashObject = "Sign_Sphere200cm_Geometry_F" createVehicle ((getPos _center) vectorAdd [0,0,30]);

//hide it
//add its reference to a global array
_array = missionNamespace getVariable ["IRN_ambient_battle_modules",[]];
_hashObject setVehicleVarName ("AmbBattleModule_" + str count _array);
_array pushBack _hashObject;
missionNamespace setVariable ["IRN_ambient_battle_modules",_array,true];
if (_debug) then {
	diag_log ["hashobject created:",_hashObject,"pushed to missionnamespace as public:",missionNamespace getVariable ["IRN_ambient_battle_modules",[]]];
};

//---------------------create an object that holds all params END

//fill hashobject with params
//core params are: distance min/max, frequency, time to stop, tracersparams [everyX, randomVec, %shots]
{
	_hashObject setVariable [_x select 0,_x select 1,true];
} foreach [
	["minDistance",_minDistance],
	["maxDistance",_maxDistance],
	["salvoFrequency",_salvoFrequency],
	["salvoAverage",_salvoAverage], //average amount of salvos per "skrimish",
	["expAverage",_expAverage],
	["end",_endTime],
	["tracerEveryX",_tracerEveryX],
	["tracersRndVec",_tracerRndVec],
	["tracerColor",_tracerColorPalette],
	["percentTracers",_percentTracers],
	["expColor",_expColorPalette],
	["expSize",_expSize],
	["expSounds",_expSounds],
	["shots",_shotSounds],
	["debug",_debug],
	["center",_center]
];

_i = 0;
_min = 800;
//list of shooting sounds
private	_shotSounds = _shotSounds;

//list of explosions
private _listExp = _expSounds;

if (true) then {
	systemChat "killing lights";
	[getPos _center] remoteExec ["IRN_fnc_killLights",0,true];
};
//debug stuff at start like markers etc.
if (_debug) then {
    diag_log ["############################## debug is ",_debug];

	//mark the center object on the map
	_centerMarker = createMarker ["center",getPos _center];
	_centerMarker setMarkerType "hd_dot";
	_centerMarker setMarkerText "sound center";

	//mark the area of hearable sound on map
	_soundMarker = createMarker ["soundarea",getPos _center];
	_soundMarker setMarkerShape "ELLIPSE";
	_soundMarker setMarkerText "sound center";
	_soundMarker setMarkerSize [_maxDistance,_maxDistance];
	_soundMarker setMarkerBrush "border";

	//notify all players
	"starting ambient_battles" remoteExec ["systemChat",0, true];
};

_start = time;

while {time < _endTime} do {
	//TODO add breakout condition
	//loop 
	_i = _i + 1;
	//update variable from hashobject, if undefined, keep using old one:
	systemChat str ["iteration:",_i];

	_minDistance = _hashObject getVariable	["minDistance",_minDistance];
	_maxDistance = _hashObject getVariable	["maxDistance",_maxDistance];
	_salvoFrequency = _hashObject getVariable	["salvoFrequency",_salvoFrequency];
	_salvoAverage = _hashObject getVariable	["salvoAverage",_salvoAverage]; //average amount of salvos per "skrimish",
	_expAverage = _hashObject getVariable	["expAverage",_expAverage];
	_endTime= _hashObject getVariable	["end",_endTime];
	_tracerEveryX = _hashObject getVariable	["tracerEveryX",_tracerEveryX];
	_tracerRndVec = _hashObject getVariable	["tracersRndVec",_tracerRndVec];
	_tracerColorPalette = _hashObject getVariable	["tracerColor",_tracerColorPalette];
	_percentTracers = _hashObject getVariable	["percentTracers",_percentTracers];
	_expColorPalette = _hashObject getVariable	["expColor",_expColorPalette];
	_expSize = _hashObject getVariable	["expSize",_expSize];
	_expSounds = _hashObject getVariable	["expSounds",_expSounds];
	_shotSounds = _hashObject getVariable	["shots",_shotSounds];
	_debug = _hashObject getVariable	["debug",_debug];
	_center = _hashObject getVariable	["center",_center];



	//--------------play sounds
	for "_i" from 0 to _salvoAverage do { //amount of salvos spawned
		//create parameters for the salvo to spawn.

		//soundfile selected for the salvos
		_sound = selectRandom _shotSounds;
	
		//amount of shots spawned/fired
		_shots = selectRandom [round (5 + random 10),3,2];

		//firerate of salvo
		_fireRate = 0.05 + random 0.3;

		//time delay until salvo is spawned, used to randomize
		_delay = round (random 5);
		
		//vector the tracers are fired at, synched
		_tracerVector = [800] call IRN_fnc_randomVector;

		//color of the tracers, synched
		_tracerColor = selectRandom _tracerColorPalette;

		//true position the tracers are fired from, synched
		_tracerPos = (getPosASL _center) vectorAdd [-100 + random 200, -100 + random 200, 0];

		//determine if flak fire or single, misplaced tracers
		_flak = [
			_tracerEveryX,		//tracers every x _shots
			_tracerRndVec,		//random angle t/f
			_percentTracers		//random chance tracer
		];

		//spawn a coroutine that creates global bullets, local tracerlights and delayed sounds for all players
		
		//TODO pass on min and max values
		[
			_sound,
			_shots,
			_fireRate,
			_delay,
			_tracerVector,
			_tracerColor,
			_tracerPos,
			_flak
		] spawn IRN_fnc_spawnSalvo; 
		

		//boolean if explosion is spawned. random chance activated, synched
		_spawnExplosion = (random 100 < (100 * _expAverage));

		if (_spawnExplosion) then {

			//simulated, synched positon of explosion
			_expPosGlobal = (getPosASL _center vectorAdd [-100 + random 200, -100 +random 200, 15]); //TODO set to posAGL z = 15 instead of ASL

			//explosion sound, synched
			_expSound = selectRandom _expSounds;
			[
				_expSound,
				1,
				0,
				0,
				[1,1,1],
				[1,1,1],
				_expPosGlobal,
				[
					1,
					false,
					0
				]
			] spawn IRN_fnc_spawnSalvo; //delayed sound for Explosion with no bullets
			[
				_expPosGlobal,
				selectRandom _expColorPalette,
				(10000 + random 40000) * _expSize
			] remoteExec ["IRN_fnc_explosionLight",0];

		};
	}; //for loop end
		
	sleep _salvoFrequency;
	systemChat str _i;
	sleep 1;
};
if (_debug) then {
	private _string = "finished ambient battles";
	systemChat _string;
	diag_log _string;
};

