//call script from initfile for cookie slot

//only run for this object
//if (owner _this != //this machine) exitWith {}
//runs local on player machine (cookie)
systemchat str this;
_handle = this spawn {
	sleep 5;
	if (_this != player) exitWith {systemChat "not local to unit"};
	private _uid = getPlayerUID player;
	hint str _uid;
	private _i = 0;
	while {true} do {
		{
			_items = assignedItems player; 
			if (_x in _items) then {
				systemChat "SIE NOOB!";
			};
			_i = _i + 1;
			player unlinkItem _x;
		} foreach ["ItemGPS","FIR_PDU"];
		sleep 5;
	};
};


