//get all markers for the task

//-- get in plane
//get all planes, get all players, assign one plane to each player.
sleep 1;
_planes = missionNamespace getVariable ["planes",[]];
_players = allPlayers;
//hint "playertasks running";
{
	_plane = _planes select _foreachIndex;
	_player = _x;
	_taskName = "getIn" + str _foreachIndex;
	[_player, [_taskname], ["Get in the plane and take off", "Get in the plane", "airfield"], _plane ,"ASSIGNED", 0, true] call BIS_fnc_taskCreate;
	_CompleteTask = {
		_taskname = _this select 0;
		_player = _this select 1;
		_plane = _this select 2;
		_goOn = false;
		//Hint str _this;
		waitUntil {	//wait until player is in plane
			sleep 1;
			_goOn = (vehicle _player == _plane);
			_goOn
		};
		[_taskname,"SUCCEEDED"] call BIS_fnc_taskSetState; //then set task to completed
		[[west, "Base"],"mp_groundsupport_05_newpilot_BHQ_0"] remoteExec ["sideRadio"];
		//[west, "Base"] sideRadio "mp_groundsupport_01_casrequested_BHQ_0";
	};
	[_taskname,_player,_plane] spawn _CompleteTask;
	
} foreach _players;

//-- take off
//-- escort konvoi
//-- defend convoi
//-- 