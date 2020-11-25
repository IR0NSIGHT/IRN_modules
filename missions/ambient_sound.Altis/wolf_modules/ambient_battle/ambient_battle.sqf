/*
made by IR0NSIGHT
a script which plays gunshots at 400m distance in the direction of a given center object.
creates illusion of nearby gunfight in the direction of the specified object, while allowing bigger distances than are possible with vanilla soundsimulation.
call skript with: 
execVM "yourlinktoskriptinMissionFolder\ambient_battles.sqf";
will only execute on the server machine.
*/
//--------------------------------------------------------------------------------------------
// will remotely call sounds on all clients (including server). define paramters in _handles array

diag_Log ["#############################################################",_this]; 
params ["_action", "_ambientbattles","_maxDistance","_debug","_duration","_dist","_center"];
/*
_module = _ambientbattles select 0;
_dist = _module getVariable "distance";
_dist = parseNumber _dist;
_duration = _module getVariable "duration";
_duration = parseNumber _duration;
_center = _module; 
_maxDistance = 3000; //maximum distance to target to still hear sounds
_headPos = _center; //declare to avoid nullpointer */

// params for debugging / use as script
//requires an object called "center" (as its varname in editor) as the soundsource. object will not be touched or teleported.
//_action = "init";
//_center = center;
//_dist = 400;
//_duration = 500;
//_debug = true;
//_maxDistance = 3000; //maximum distance to target to still hear sounds

if (!isServer || _action !="init") exitWith {}; //only executes ingame, not in Eden

private _i = 0; //iteration counter
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

if (_debug) then {
	//hint "starting audio";
	"starting ambient_battles" remoteExec ["hint",0, true];
};

_start = time;
_end = _start + _duration;

//kill all lights
[
	getPos _center
] call IRN_fnc_killLights;

while {time < _end} do {
	//loop
	_i = _i + 1;
	if (_debug) then {
		hint str _i;	
	};
	//--------collect source position individual to player
	//foreach player, calculate soundsource position and store.
	_sourcesList = [];
	{
		//get soundsource pos of player
		_sourcePos = [getPosASL _x,getPosASL _center,_dist,[0,0,0]] call IRN_fnc_calcSoundPos; //["_player","_center","_dist","_headPos"]
		_sourcesList pushBack [_x,_sourcePos]; //save calculated position to list for later use

	} forEach allPlayers;
	if (_debug) then {
		diag_log ["#################################################################calculated pos for players",_sourcesList];
	};
	//--------------play sounds

	if (true) then { //at 5% chance spawn a single rare sound (big explosion and the like)
		_sound = selectRandom _listShots;
	
		_shots = selectRandom [round (10 + random 20),3,2];
		_delay = round (random 5);
		
		_tracerVector = [400] call IRN_fnc_randomVector;
		_tracerColor = [1,random 1,0.2];
		_tracerPos = (getPosASL _center) vectorAdd [-100 + random 200, -100 + random 200, 0];
		_spawnExplosion = random 100; systemChat str _spawnExplosion; _spawnExplosion = (_spawnExplosion < 50);
		_expPosGlobal = (getPosASL _center vectorAdd [-100 + random 200, -100 +random 200, 15]); //TODO set to posAGL z = 15 instead of ASL
		_expSound = selectRandom _listRare;
		diag_log "trying to spawn sounds";
	//FIXME clean up variables
		{ //code in here is individual to each player!!
			//[player, sourepos in posASL]
			_pos = _x select 1;
			_player = _x select 0;
			_id = owner _player; //you cant own a person ! thats racist!
			_volume = 0.6 + 0.4 * ([(_player distance _expPosGlobal),0,_maxDistance,true] call IRN_fnc_interpolate);
			_expVol = _volume + 0.2;
			diag_log ["player is at ",_expVol," percent of full Volume"];
			systemChat str ["_volume: ", _volume];
			diag_log ["remote calling sound for player ",[_sound,_pos,_shots,_delay,_volume,_tracerVector,_tracerColor,_tracerPos]];
			//["_sound","_pos","_shots","_delay","_volume"]
			[
				_sound,
				_pos,
				_shots,
				_delay,
				_volume,
				_tracerVector,
				_tracerColor,
				_tracerPos
			] remoteExec ["IRN_fnc_spawnSalvo",_id,false]; //NOTE: jip true collects sounds to play at joining
			//["_pos","_color","_size","_intensity"]
			//------------------------------explosions
			if (_spawnExplosion) then { //random 100 < 10
				if (_debug) then {
					systemChat "boom";
				};
				_expposLocal = [getPosASL _player,_expPosGlobal,_dist] call IRN_fnc_calcSoundPos;
				[
					_expPosGlobal,
					[1,0.7,0.2],
					0.1,
					100000
				] remoteExec ["IRN_fnc_explosionLight",_id,false];

				if (_debug) then {
					diag_log ["############## spawning explosions with parameters: ",["soundfile",_expSound,"object", nil, "jip", false, "position",_expPosGlobal, "volume",_expVol, 0, 0],"on client",_id,"jip:",false];
				};
				//todo add sound delay based on distance -> correct sound travel time
				[[_expSound, nil, false, _expposLocal, _expVol, 1, 0]] remoteExec ["playSound3D",_id,false] ; // play sound !double array is required
			};
		} forEach _sourcesList;	
		
		
		
	};
	sleep random 5;
};
if (_debug) then {
	hint ("player to soundsource: " + str (getPosASL player distance _headPos));
	hint "finished audio";
};

