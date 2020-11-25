//configfile >> "CfgRadio" >> "mp_groundsupport_01_casrequested_OHQ_2"
//player sideRadio "mp_groundsupport_01_casrequested_OHQ_2"

_pathArray =  ("true" configClasses (configfile >> "RadioProtocolENG" >> "Words"));
_logArr = [];
_end = ((count _pathArray) - 1);

_start = 0;
//remove all doubles



//_end = 1;

for "_i" from _start to _end step 1 do {
	_idx = _i;
    _path = _pathArray select _idx;
	_path = selectRandom _pathArray;
	_className = configName _path;
	if (true) then {	//enough
		hint str _classname;
		_logArr pushBack _className;
	} else {
		//_i = _i - 1;
	};



};
_logArr = _logArr arrayIntersect _logArr; // _result is [1, 2, 3, 4]
copyToClipboard str _logArr;
	_log2 = [];
	hint( "log arr is " + str count _logArr); sleep 1;
	{
		//player sideRadio _x;
		playSound3D ["RadioProtocolENG\Normal\DirectionCompass2\bearing255.ogg", player]
		//playSound _x;
		//_source = ASLToAGL [0,0,0] nearestObject "#soundonvehicle"; _start = time;hint str [ _x,_foreachIndex];
		//waitUntil {isNull _source};
		sleep 2;
		_l = time - _start;
		_log2 pushback [_x,_foreachIndex,_l];
	} foreach _logArr;
copyToClipboard str _log2;
//hint "DONE";

