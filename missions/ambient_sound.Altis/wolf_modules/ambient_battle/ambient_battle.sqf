/*
made by IR0NSIGHT
a script which plays gunshots at 400m distance in the direction of a given center object.
creates illusion of nearby gunfight in the direction of the specified object, while allowing bigger distances than are possible with vanilla soundsimulation.

will only execute on the server machine and remotely execute sounds on all clients.
*/
//--------------------------------------------------------------------------------------------

//FIXME clean up variables

diag_Log ["----------","IRN_ambient_battle with params",_this]; 

//TODO move input parameters here
params ["_action", "_ambientbattle","_maxDistance","_debug","_duration","_dist","_center"];

if (!isServer || _action !="init") exitWith {}; //only executes ingame, not in Eden

//technical variables
private ["_i","_start","_end","_expPosGlobal","_expSound","_min"];
_i = 0;
_min = 800;
//list of shooting sounds
private	_listShots = [
		"A3\Sounds_F\weapons\HMG\HMG_gun.wss",
		"A3\Sounds_F\weapons\M4\m4_st_1.wss",
		//"A3\Sounds_F\weapons\M200\M200_burst.wss",
		"A3\Sounds_F\weapons\mk20\mk20_shot_1.wss"
];

//list of explosions
private _listExp = [
	//	"A3\Sounds_F\weapons\Explosion\explosion_antitank_1.wss", flashbang sound
	//	"A3\Sounds_F\weapons\Explosion\expl_shell_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_2.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_3.wss"
];

if (true) then {
	systemChat "killing lights";
	[getPos _center] call IRN_fnc_killLights;
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
_end = _start + _duration;

//TODO create object
_hashObject = center;

while {time < _end} do {
	//TODO add breakout condition
	//loop 
	_i = _i + 1;

	//--------------play sounds
	for "_i" from 0 to 1 do { //amount of salvos spawned
		//create parameters for the salvo to spawn.

		//soundfile selected for the salvos
		_sound = selectRandom _listShots;
	
		//amount of shots spawned/fired
		_shots = selectRandom [round (5 + random 10),3,2];

		//firerate of salvo
		_fireRate = 0.05 + random 0.3;

		//time delay until salvo is spawned, used to randomize
		_delay = round (random 5);
		
		//vector the tracers are fired at, synched
		_tracerVector = [800] call IRN_fnc_randomVector;

		//color of the tracers, synched
		_tracerColor = [1,random 1,0.2];

		//true position the tracers are fired from, synched
		_tracerPos = (getPosASL _center) vectorAdd [-100 + random 200, -100 + random 200, 0];

		//determine if flak fire or single, misplaced tracers
		_flak = [
			5,		//tracers every x _shots
			true,	//random angle
			0.2		//random chance tracer
		];

		//spawn a coroutine that creates global bullets, local tracerlights and delayed sounds for all players
		
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
		_spawnExplosion = (random 100 < 20);
		if (_spawnExplosion) then {
			//simulated, synched positon of explosion
			_expPosGlobal = (getPosASL _center vectorAdd [-100 + random 200, -100 +random 200, 15]); //TODO set to posAGL z = 15 instead of ASL

			//explosion sound, synched
			_expSound = selectRandom _listExp;
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
			] spawn IRN_fnc_spawnSalvo; //delayed sound for Explosion
			[_expPosGlobal,[0.9 + random 0.1,0.8 + random 0.2,0.6 + random 0.2],(30000 + random 70000)] remoteExec ["IRN_fnc_explosionLight",0];

		};
	}; //for loop end
		
	sleep 1;
	systemChat str _i;
	sleep 1;
};
if (_debug) then {
	private _string = "finished ambient battles";
	systemChat _string;
	diag_log _string;
};

