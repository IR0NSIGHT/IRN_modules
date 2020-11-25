configfile >> "CfgRadio" >> "mp_groundsupport_01_casrequested_OHQ_2"
player sideRadio "mp_groundsupport_01_casrequested_OHQ_2"

_pathArray =  ("true" configClasses (configFile >> "CfgRadio"));
for "_i" from 0 to ((count _pathArray) - 1) do {
	_idx = _i;
    _path = _pathArray select _idx;
	_className = configName _path;
	player sideRadio _className;
	sleep 4;
};
