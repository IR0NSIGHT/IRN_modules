diag_log ["initAmbBattle with params: ",_this];
_logic = _this select 1 select 0;
//get user-set attributes from module
_num = _logic getVariable ["MyNumber",-1];
diag_log str ["myNumber = ",_num];

	_minDistance = _logic getVariable	["minDistance",800];
	_maxDistance = _logic getVariable	["maxDistance",300];
	_salvoFrequency = _logic getVariable	["salvoFrequency",10];
	_salvoAverage = 2* (_logic getVariable	["salvoAverage",3]); //average amount of salvos per "skrimish",
	_expAverage = _logic getVariable	["expAverage",0.2];
	_endTime= time + (_logic getVariable ["end",600]);
	_tracerEveryX = _logic getVariable	["tracerEveryX",5];
	_tracerRndVec = _logic getVariable	["tracersRndVec",1];
	if (_tracerRndVec == 1) then {
		_tracerRndVec = true;
	} else {
		_tracerRndVec = false;
	};
	_tracerColorPalette = parseSimpleArray (_logic getVariable	["tracerColor",[[1,0,1]]]);

	_percentTracers = _logic getVariable	["percentTracers",0.2];

	_expColorPalette = parseSimpleArray (_logic getVariable	["expColor",[[1,1,0],[0,1,1]]]);

	_expSize = _logic getVariable	["expSize",0.5];

	_expSounds = parseSimpleArray ( _logic getVariable	["expSounds",["A3\Sounds_F\weapons\Explosion\expl_big_1.wss","A3\Sounds_F\weapons\Explosion\expl_big_2.wss","A3\Sounds_F\weapons\Explosion\expl_big_3.wss"]]);
	
	_shotSounds = parseSimpleArray (_logic getVariable	["shots",["A3\Sounds_F\weapons\HMG\HMG_gun.wss","A3\Sounds_F\weapons\M4\m4_st_1.wss","A3\Sounds_F\weapons\mk20\mk20_shot_1.wss"]]);
	
	_debug = _logic getVariable	["debug",0];
	if (_debug == 1) then {
		_debug = true;
	} else {
		_debug = false;
	};
	
	_center = _logic;

if (_this select 0 != "init") exitWith {diag_log "not init for amb battle"}; 
[
	_minDistance,
	_maxDistance,
	_salvoFrequency,
	_salvoAverage,
	_expAverage,
	_endTime,
	_tracerEveryX,
	_tracerRndVec,
	_tracerColorPalette,
	_percentTracers,
	_expColorPalette,
	_expSize,
	_expSounds,
	_shotSounds,
	_debug,
	_center
] execVM "wolf_modules\ambient_battle\ambient_battle.sqf";	