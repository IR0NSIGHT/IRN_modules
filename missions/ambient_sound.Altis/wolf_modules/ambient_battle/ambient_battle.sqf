/*
made by IR0NSIGHT
a script which plays gunshots at 400m distance in the direction of a given center object.
creates illusion of nearby gunfight in the direction of the specified object, while allowing bigger distances than are possible with vanilla soundsimulation.

will only execute on the server machine and remotely execute sounds on all clients.
*/
//--------------------------------------------------------------------------------------------
// will remotely call sounds on all clients (including server). define paramters in _handles array


diag_Log ["----------","INR_ambient_battle",_this]; 

params ["_action", "_ambientbattle","_maxDistance","_debug","_duration","_dist","_center"];

if (!isServer || _action !="init") exitWith {}; //only executes ingame, not in Eden

//iteration counter
private _i = 0; 
private ["_posC","_posP","_direction","_dirNorm","_dist","_center","_source"];
private	_listShots = [
		"A3\Sounds_F\weapons\HMG\HMG_gun.wss",
		"A3\Sounds_F\weapons\M4\m4_st_1.wss",
		//"A3\Sounds_F\weapons\M200\M200_burst.wss",
		"A3\Sounds_F\weapons\mk20\mk20_shot_1.wss"
];
private _listRare = [
	//	"A3\Sounds_F\weapons\Explosion\explosion_antitank_1.wss", flashbang sound
	//	"A3\Sounds_F\weapons\Explosion\expl_shell_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_2.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_3.wss"
];
_debug = true;
if (_debug) then {
    diag_log ["############################## debug is ",_debug];
	//hint "starting audio";
	//_soundAreaMarker = createMarker ["sound area",getPos _center];

	_centerMarker = createMarker ["center",getPos _center];
	_centerMarker setMarkerType "hd_dot";
	_centerMarker setMarkerText "sound center";

	_soundMarker = createMarker ["soundarea",getPos _center];
	_soundMarker setMarkerShape "ELLIPSE";
	_soundMarker setMarkerText "sound center";
	_soundMarker setMarkerSize [_maxDistance,_maxDistance];
	_soundMarker setMarkerBrush "border";
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
		//get soundsource pos of player
		_sourcePos = [getPosASL _x,getPosASL _center,_dist,[0,0,0]] call IRN_fnc_calcSoundPos; //["_player","_center","_dist","_headPos"]
		_player = _x;
		_idx = _sourcesList findif {_player in _x};
		if (_idx == -1) then {
			diag_log "first entry for player";
			_sourcesList pushBack [_player,_sourcePos];
		} else {
			(_sourcesList select _foreachIndex) set [1,_sourcePos];
			diag_log ["overwrote pos for player",_player,_sourcesList select _foreachIndex select 1];
		}
		//_sourcesList pushBack [_x,_sourcePos]; //save calculated position to list for later use
	} forEach allPlayers;
	diag_log ["sourceslist:",_sourcesList];
	if (_debug) then {
		//diag_log ["#################################################################calculated pos for players",_sourcesList];
	};
	//--------------play sounds

	for "_i" from 0 to 1 do { //at 5% chance spawn a single rare sound (big explosion and the like)
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

		//simulated, synched positon of explosion
		_expPosGlobal = (getPosASL _center vectorAdd [-100 + random 200, -100 +random 200, 15]); //TODO set to posAGL z = 15 instead of ASL

		//explosion sound, synched
		_expSound = selectRandom _listRare;

	//FIXME clean up variables
		{ //code in here is individual to each player!!
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

			//delay by traveltime of sound
			_distanceDelay = [333,(_player distance _center)] call IRN_fnc_travelTime;

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
			if (_spawnExplosion) then { //random 100 < 10
				if (_debug) then {
				//	systemChat "boom";
				};
				_expposLocal = [getPosASL _player,_expPosGlobal,_dist] call IRN_fnc_calcSoundPos;
				[
					_expPosGlobal,
					[1,0.7,0.2],
					0.1,
					100000
				] remoteExec ["IRN_fnc_explosionLight",_id,false];

				//todo add sound delay based on distance -> correct sound travel time
				[_expSound,_expposLocal,_expVol,_id,_distanceDelay] spawn {
					params ["_expSound","_expposLocal","_expVol","_id","_distanceDelay"];
					//systemChat ("explosion in " + str _distanceDelay);
					sleep _distanceDelay;
					[[_expSound, nil, false, _expposLocal, _expVol, 1, 0]] remoteExec ["playSound3D",_id,false] ; // play sound !double array is required
				};
			};

			//DEBUG
			if (_debug) then {
				_marker = _x select 2;
				
				if (isNil "_marker") then {
					_name = name _player + "_soundmarker";
					_marker = createMarker [_name, _pos];
					_marker setMarkerType "hd_dot";
					_marker setMarkerText (name _player);
					_sourcesList set [_foreachIndex,[_player,_pos,_marker]];
					diag_log ["for marker: ",_marker,"added marker:",_sourcesList select _foreachIndex];
				} else {
					diag_log ["marker already exists: ",_marker];
					_marker = _x select 2;
					_marker setMarkerPos _pos;
				};
				diag_log ("marker is: " + _marker);
			}
		} forEach _sourcesList;	
		diag_log _sourcesList;
		
		
	};
	sleep random 5;
};
if (_debug) then {
	systemChat ("player to soundsource: " + str (getPosASL player distance _center));
	systemChat "finished audio";
};

