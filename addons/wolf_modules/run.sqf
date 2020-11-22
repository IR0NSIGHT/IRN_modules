diag_log "yeet";

_handle = [] spawn {
	_i = 0;
	_start = diag_tickTime;
	while {_i < 50000000} do {
		//sleep 1;
		//hint str _i;
		_i = _i + 1;
	};
	_duration = (diag_tickTime - _start) / 1000; 
	hint ("took " + str _duration + " seconds");
}
