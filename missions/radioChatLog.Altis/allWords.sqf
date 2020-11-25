
_pathArray =  (configProperties [configfile >> "RadioProtocolENG" >> "Words"]);
_logArr = [];
_end = ((count _pathArray) - 1);
_start = 0;
hint str ["logarr has ", count _pathArray, "paths"];
for "_i" from _start to _end step 1 do {
	_idx = _i;
    _path = _pathArray select _idx;
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

// configName configClass configfile >> "RadioProtocolENG" >> "Words" >> "Normal"
