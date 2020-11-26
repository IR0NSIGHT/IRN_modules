/*
made by IR0NSIGHT
a script which plays gunshots at 400m distance in the direction of a given center object.
creates illusion of nearby gunfight in the direction of the specified object, while allowing bigger distances than are possible with vanilla soundsimulation.

will only execute on the server machine and remotely execute sounds on all clients.
*/
//--------------------------------------------------------------------------------------------

//FIXME clean up variables

diag_Log ["----------","IRN_ambient_battle",_this]; 

//TODO move input parameters here
params ["_action", "_ambientbattle","_maxDistance","_debug","_duration","_dist","_center"];

if (!isServer || _action !="init") exitWith {}; //only executes ingame, not in Eden

//technical variables
private ["_i","_start","_end"];
_i = 0;

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

//kill all lights
[
	getPos _center
] call IRN_fnc_killLights;
_sourcesList = [];

while {time < _end} do {
	//loop
	_i = _i + 1;
	if (_debug) then {
		systemChat ("round: " + str _i);	
	};

	//--------collect source position individual to player
	//foreach player, calculate soundsource position and store.
	{
		_sourcePos = [getPosASL _x,getPosASL _center,_dist,[0,0,0]] call IRN_fnc_calcSoundPos;
		_player = _x;
		_idx = _sourcesList findif {_player in _x};
		if (_idx == -1) then {
			//diag_log "first entry for player";
			_sourcesList pushBack [_player,_sourcePos];
		} else {
			(_sourcesList select _foreachIndex) set [1,_sourcePos];
			//diag_log ["overwrote pos for player",_player,_sourcesList select _foreachIndex select 1];
		}
	} forEach allPlayers;

	
	if (_debug) then {
		diag_log ["#################################################################calculated pos for players, sourceslist:",_sourcesList];
	};

	//--------------play sounds
	for "_i" from 0 to 1 do {
		//soundfile selected for the salvos
		_sound = selectRandom _listShots;
	
		//amount of shots spawned/fired
		_shots = selectRandom [round (10 + random 20),3,2];

		//time delay until salvo is spawned, used to randomize
		_delay = round (random 5);
		
		//vector the tracers are fired at, synched
		_tracerVector = [400] call IRN_fnc_randomVector;

		//color of the tracers, synched
		_tracerColor = [1,random 1,0.2];

		//true position the tracers are fired from, synched
		_tracerPos = (getPosASL _center) vectorAdd [-100 + random 200, -100 + random 200, 0];

		//boolean if explosion is spawned. random chance activated, synched
		_spawnExplosion = (random 100 < 20);

		if (_spawnExplosion) then {
			//simulated, synched positon of explosion
			_expPosGlobal = (getPosASL _center vectorAdd [-100 + random 200, -100 +random 200, 15]); //TODO set to posAGL z = 15 instead of ASL

			//explosion sound, synched
			_expSound = selectRandom _listExp;
		};

		{ //FOREACH PLAYER  --- code in here is individual to each player!!
			//local soundsource for player
			_pos = _x select 1;

			//playerobject
			_player = _x select 0;

			//machine id of player for remoteexec
			_id = owner _player; //you cant own a person ! thats racist!

			//volume that sounds play at, depends on distance to _center
			_volume = 0.6 + 0.4 * ([(_player distance _expPosGlobal),0,_maxDistance,true] call IRN_fnc_interpolate);

			//volume that explosions play at. slightly higher than shots.
			_expVol = _volume + 0.2;

			//time delay between tracers and sounds bc traveltime of sound
			_distanceDelay = [333,(_player distance _center)] call IRN_fnc_travelTime;

			//spawn a salvo with params, consisting of tracers and sound
			[
				_sound,
				_pos,
				_shots,
				_delay,
				_distanceDelay,
				_volume,
				_tracerVector,
				_tracerColor,
				_tracerPos
			] remoteExec ["IRN_fnc_spawnSalvo",_id,false]; //NOTE: jip true collects sounds to play at joining

			//------------------------------explosions
			if (_spawnExplosion) then {

				_expposLocal = [getPosASL _player,_expPosGlobal,_dist] call IRN_fnc_calcSoundPos;

				private ["_colour","_lifeTime","_intensity"];

				//colour of explosion in rgb
				_colour = [1,0.7,0.2];

				//life time of explosion light in seconds
				_lifeTime = 0.1;

				//intensity/brightness of explosion light
				_intensity = 100000;

				//spawn explosion light, will spawn at the global, synched position near the module, but light is local to every player
				[
					_expPosGlobal,
					_colour, 
					_lifeTime,
					_intensity
				] remoteExec ["IRN_fnc_explosionLight",_id,false];

				//spawn a delayed sound effect for the explosion
				//TODO introduce delayed remotesound as custom function? use in spawnSalvo
				[_expSound,_expposLocal,_expVol,_id,_distanceDelay] spawn {

					params ["_expSound","_expposLocal","_expVol","_id","_distanceDelay"];

					sleep _distanceDelay;

					[[_expSound, nil, false, _expposLocal, _expVol, 1, 0]] remoteExec ["playSound3D",_id] ; // play sound !double array is required

				};
			};

			//DEBUG
			if (_debug) then {
				
				//create/update a marker for each player, put at position of soundsource
				_marker = _x select 2;
				
				if (isNil "_marker") then {
					_name = name _player + "_soundmarker";
					_marker = createMarker [_name, _pos];
					_marker setMarkerType "hd_dot";
					_marker setMarkerText (name _player);
					_sourcesList set [_foreachIndex,[_player,_pos,_marker]];	
				} else {	
					_marker = _x select 2;
					_marker setMarkerPos _pos;
				};
			}
		} forEach _sourcesList;	
	}; //for loop end
	sleep random 5;
};
if (_debug) then {
	private _string = "finished ambient battles";
	systemChat _string;
	diag_log _string;
};

