diag_log "intiAB";
//sleep 5;
hint "initAB";
//["hello"] call IRN_fnc_testFunction;
//["_minDistance","_maxDistance","_salvoFrequency","_salvoAverage","_expAverage","_endTime","_everyX","_rndVec","_percentTracers","_expColorPalette","_expSize","_expSounds","_shotSounds","_debug","_center"];
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
		//"A3\Sounds_F_arsenal\\Explosives\shells\artillery_shell_explosion_01.wss"
];

[
	800,4000,3,3,0.2,
	time + 6000,1,true,
	1,[[1,1,0],[0,1,1]]
	,3,_listExp,_listShots,
	true,center
] execVM "wolf_modules\ambient_battle\ambient_battle.sqf";