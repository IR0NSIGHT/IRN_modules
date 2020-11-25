	_distance = 12345; _message = []; _sound = "";
	_numberArr = ( str _distance) splitSTring ""; //100 -> "100"
	{
		_condition = _x;	//string consisitng of 1 letter: "1" f.e.
		systemChat format ["cond x = ",_condition];
		switch (_condition) do {
			case "0":{			};
			case "1":{	 _sound =  "ot_one";		};
			case "2":{	 _sound = "ot_two";		};
			case "3":{	 _sound = "ot_three";		};
			case "4":{	 _sound = "ot_four";		};
			case "5":{	 _sound = "ot_five";		};
			case "6":{	 _sound = "ot_six";		};
			case "7":{	 _sound = "ot_seven";		};
			case "8":{	 _sound = "ot_eight";		};
			case "9":{	 _sound = "ot_nine";		};
			default {};
		};
		if !(_message isEqualTo "") then {
			_message pushBack _sound;
		};
	} foreach _numberArr;
	hint str _message;

	[[player, ["Arsenal", {["Open", true] call BIS_fnc_arsenal;}]], "addAction", true, true] call BIS_fnc_MP;

	_myFunction = {
		params ["_coolVar1","_uberCoolerVar2"];
		hint format ["hello there %1, %2",_coolVar1,_uberCoolerVar2];
	};
	["General Kenobi","*lightsaber ignites*"];
	{hint "hello there"; } remoteExec ["call",0,true];
