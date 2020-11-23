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

diag_Log ["#############################################################", _this]; 
params ["_action", "_ambientbattles","_maxDistance","_debug","_duration","_dist","_center"];

_module = _ambientbattles select 0;
_dist = _module getVariable "distance";
_dist = parseNumber _dist;
_duration = _module getVariable "duration";
_duration = parseNumber _duration;
_center = _module; 
_maxDistance = 3000; //maximum distance to target to still hear sounds
_headPos = _center; //declare to avoid nullpointer
/* params for debugging / use as script
//requires an object called "center" (as its varname in editor) as the soundsource. object will not be touched or teleported.
_action = "init";
_center = center;
_dist = 400;
_duration = 500;
_debug = true;
_maxDistance = 3000; //maximum distance to target to still hear sounds
*/
if (!isServer || _action !="init") exitWith {}; //only executes ingame, not in Eden

private _i = 0; //iteration counter
private ["_posC","_posP","_direction","_dirNorm","_dist","_center","_source"];
private	_listShots = [
		"A3\Sounds_F\weapons\HMG\HMG_gun.wss",
		"A3\Sounds_F\weapons\M4\m4_st_1.wss",
		"A3\Sounds_F\weapons\M200\M200_burst.wss",
		"A3\Sounds_F\weapons\mk20\mk20_shot_1.wss"
];
private _listRare = [
		"A3\Sounds_F\weapons\Explosion\explosion_antitank_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_shell_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_1.wss"
];



if (_debug) then {
	//hint "starting audio";
	"starting ambient_battles" remoteExec ["hint",0, true];
};

_start = time;
_end = _start + _duration;
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
		_sourcePos =[_x,_center,_dist,[0,0,0]] call IRN_fnc_calcSoundPos; //["_player","_center","_dist","_headPos"]
		_sourcesList pushBack [_x,_sourcePos]; //save calculated position to list for later use
		if (_debug) then {
			diag_log str [_x,_sourcePos];
		};
	} forEach allPlayers;

	//--------------play sounds
	if (random 100 < 5) then { //at 5% chance spawn a single rare sound (big explosion and the like)
		_sound = selectRandom _listShots;
	
		_shots = random 20;
		_delay = random 20;
		_volume = 0.5 + random 0.5;
	//FIXME clean up variables
		{ //code in here is individual to each player!!
			//[player, sourepos in posASL]
			_pos = _x select 1;
			_player = _x select 0;
			_id = owner _player; //you cant own a person ! thats racist!
			/**["_sound","_pos","_shots","_delay","_volume"]*/
			[
				_sound,
				_pos,
				_shots,
				_delay,
				_volume
			] remoteExec ["IRN_spawnSalvo",_id,true];
		} forEach _sourcesList
		
	};
	//TODO change calculatePos to be able to use from global. -> GetPosSourceForPlayer(x)
	sleep random 20;
};
if (_debug) then {
	hint ("player to soundsource: " + str (getPosASL player distance _headPos));
	hint "finished audio";
};

