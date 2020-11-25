//add ace action to specified crates (anything that has inventory?)
hint "I WAS CALLED";
IRN_fnc_addViVAction = {
	//runs local to client
	params["_class"]; //crate to add viv action to
	//load statement code
	_loadCode = { 
		params ["_target", "_player"];
		_box = _target;
		hint str _box;
		_list = (_box nearEntities 10) select {_r = _x canVehicleCargo _box; (_r select 1)}; 
		_list = _list apply {[_x distance _box, _x]}; 
		_list sort true;   _car = _list select 0 select 1; 
		player globalChat ("sorting through: " + str _list); 
		player globalChat ("chose: " + str _car); 
		_car setVehicleCargo _box ; 
	}; 
	//load action usable BIS_fnc_conditionalSelect
	_loadAvailable = {
		params ["_box", "_player"];
		//params["_box"];
		_list = (_box nearEntities 10) select {_r = _x canVehicleCargo _box; (_r select 1)}; //all cars nearby that can lift the box (theoretically)
		(count _list > 0 && isNull (isVehicleCargo _box)) //one or more cars available and not cargo
	};

	//create load action
	_loadAction = [
		"load_viv", //name	
		"Load ViV", //dispaly name
		"",	//icon
		_loadCode, //code to run on action performed 
		_loadAvailable, //condition code _loadAvailable
		{}, //insert children code
		[], //action parameters
		[0,0,0], //position
		100 //distance
	] call ACE_interact_menu_fnc_createAction;



	//add to class
	
	[_class,0,["ACE_MainActions"],_loadAction,true] call ace_interact_menu_fnc_addActionToClass;
	//----------------------------------UNLOADING-------------------------------------------------
	_unloadAvailable = {
		params["_box"];
		(!isNull (isVehicleCargo _box))
	};

	_unLoadCode = {
		params["_box"];
		_carrier = isVehicleCargo _box;
		if (isNull _carrier) exitWith {hint "is not cargo"};
		_success = objNull setVehicleCargo _box;
	};

	_unloadAction = [
		"unload_viv", //name	
		"unload ViV", //dispaly name
		"",	//icon
		_unLoadCode, //code to run on action performed 
		_unloadAvailable, //condition code _loadAvailable
		{}, //insert children code
		[], //action parameters
		[0,0,0], //position
		100 //distance
	] call ACE_interact_menu_fnc_createAction;

	[_class,0,["ACE_MainActions"],_unloadAction,false] call ace_interact_menu_fnc_addActionToClass;
};
["All"] call IRN_fnc_addViVAction; //"Quadbike_01_base_F"