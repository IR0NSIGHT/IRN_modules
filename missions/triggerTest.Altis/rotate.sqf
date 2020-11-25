_dir = 0;	_beep = "boop";
while {alive _this} do {
	_pos = getPos targetT;
	_this doWatch _pos;
	sleep 0.5;
	if (_beep == "boop") then {
		_beep = "beep";
	} else {
		_beep = "boop";
	};
	hint _beep;
}