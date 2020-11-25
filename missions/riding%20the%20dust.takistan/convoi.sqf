//this execVM "convoi.sqf";
//get start point
//get all waypoints
//get vehicles


//mark enemy positions with smoke
_unit = _this;	//blufor driver
//_grp = createGroup west;
//_unit = "B_RangeMaster_F" createUnit [[0,0,0], _grp];
//get all vehicles
convoiLeader kbAddTopic ["DynamicSay", "Conversation.bikb"];
//get all artillery elements
hint "CONVOI SCRIPT RUNNING";
_oldtime = 0;
_stress = 0;
//hint "CONVOI RUNNING";
_casClasses = ["mp_groundsupport_01_casrequested_BHQ_1","mp_groundsupport_01_casrequested_BHQ_2","mp_groundsupport_01_casrequested_BHQ_0"];
while {true} do {
	{	//make all cars meet
		_unit = _x;
		_leader = leader group _unit;
		if ((_unit != (_leader)) && ((_unit distance (_leader)) > 25)) then { //if the cars try to run away from the convoi
			_add = [-5 + round random 10,-5 + round random 10,0];
			_leaderPos = position _leader;
			_pos = _leaderPos vectorAdd _add;
			_unit doMove _pos;	//move all cars to leaders pos.
		};
	} foreach units group _unit;
//--------------- get all enemies and mark some of them for cas

	_enemies = _unit nearTargets 500;
	_enemies = _enemies select {(_unit knowsAbout (_x select 4)) > 0 && _x select 2 == EAST}; //get all opfor that the blufor unit knows knowsAbout

	_message = ["one"];
	if (count _enemies > 0) then {
		_stress = _stress + 1;
		_time = time;
		if (_time > _oldtime + 300) then {
			//didnt have enemy contact in last 5 min, broadcast to plane again.
			[_unit,"we are being engaged by hostiles, commence air support. Fire at will."] remoteExec ["sidechat"];
		};
		_revealX = random [1,1,5];	//number to reveal
		for "_i" from 1 to _revealX do {	//reveal a bunch of enemies by marking them with smoke
			if (count _enemies > 0) then {
				_idx = floor random count _enemies;	//get random index
				_enemy = _enemies select _idx select 4;
				_enemies deleteAt _idx;
				if (!isNull _enemy) then {

					_pos = getPos _enemy;
					_smoker = "SmokeShellRed" createVehicle position _enemy;
					//hint str _enemy;
					//sleep random [10,15,30];
				};

			};
		};
		
		_broadcastMessage = "We have marked the position of hostile units with red smoke. Engage at will.";
		[_unit,_broadcastMessage] remoteExec ["sidechat"];
		[[west, "Base"],selectRandom _casClasses] remoteExec ["sideRadio"];
		//hint "marking with smoke";
		_oldtime = _time;
		if (random 3 > 1) then {	//in 30% of cases, mark own pos with blue smoke
			_broadcastMessage = "friendy units marked their own position with blue smoke. Watch out for our own guys!";
			[_unit,_broadcastMessage] remoteExec ["sidechat"];
			_smoker = "SmokeShellBlue" createVehicle position _unit;
		};
		_message = ["veh_infantry_p","PrepareForContact"];
		_radio = [];
		//hint "contact";

		If (_stress < 6) then {
			_radio = ["mp_groundsupport_25_enemycapturingsector_BHQ_0","mp_groundsupport_25_enemycapturingsector_BHQ_1","mp_groundsupport_25_enemycapturingsector_BHQ_2"];
		};
		if (_stress < 3) then {
			_radio = ["mp_groundsupport_20_lowticketsenemy_BHQ_0","mp_groundsupport_20_lowticketsenemy_BHQ_1","mp_groundsupport_20_lowticketsenemy_BHQ_2"];
		};
		if (_stress >= 6) then {
			//order artilley strike
			
			_allTargets = _enemies select {((_x select 4) distance _unit) > 200};
			if (count _allTargets > 0) then {
				_target = (selectRandom _allTargets) select 4;	//random select an enemy further than 200m away
				//hint str ["all targets",_allTargets];
				//sleep 5;
				//hint str ["target",_target];
				//sleep 5;
				 
				[FireSupport, position _target, objNull, 2, ""] call BIS_fnc_wpArtillery;
				{
					(vehicle _x) setVehicleAmmo 1;
					//hint str ["ammo to 1 for ",_x];
					sleep 1;
				} forEach units FireSupport;
				/*for "_i" from 0 to ((count _arties) - 1) do {
					_thisArty = _arties select _i;
					
    				_isInRange = getPos _target inRangeOfArtillery [_arties, ""];
					[_thisArty,getPos _target,"",100,24,[2,4]] spawn BIS_fnc_fireSupport;
					//_thisArty setVehicleAmmo 1;
					hint str ["thisarty",_thisArty];
					sleep 5;
					//_thisArty doArtilleryFire [_target, "", 3]; //give each artillery fire order
					hint "FIRING ARTILLERY";
				};*/
				//reduce stress
				_stress = _stress - 3;
				_radio = ["mp_groundsupport_45_artillery_BHQ_0","mp_groundsupport_45_artillery_BHQ_1","mp_groundsupport_45_artillery_BHQ_2"];
			}

		};
		[[west, "Base"],selectRandom _radio] remoteExec ["sideRadio"];
		
	} else {
		_stress = _stress - 1;
		_message = ["AreaClear","HoldFire","GenCmdTargetEscort"];
		//hint "clear";
	};
	_message execVM "CAS.sqf";
	//hint ("running at " + str time);
	sleep 10;
	if (_stress > 0) then {	//give sitrep more often if stress is high
		sleep 60 * random [1,2,3];	
	} else {
		sleep 60 * random [3,4,5];
	};
	// cap stresslevel
	if (_stress < 0) then {
		_stress = 0;
	};
	if (_stress > 6) then {
		_stress = 6;
	};
	//hint str [_stress,"stress"];
};


