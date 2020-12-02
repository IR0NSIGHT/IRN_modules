//empty list that will hold all already active camSetPos
_activatedCamps = [];

//loop that checks for player proximity to non-active camps every 2 seconds
while {true} do {
    _inactiveCamps = ["marker_0","marker_1","marker_2"] select {
        //filter out already active camps from this array
            !(_x in _activatedCamps)
        };

    { //player forloop _x = player here
        _player = _x;
        {  //marker forloop _x = marker_n here
            _distanceToCamp = _player distance (getMarkerPos _x);
            if (_distanceToCamp < 2000) then {
                _activatedCamps pushBack _x;
                execVM "spawn_guards.sqf";
            };
        } foreach _inactiveCamps;
    } foreach allPlayers;
    sleep 2;
};







player addEventHandler[ "TaskSetAsCurrent", { 
 params ["_unit", "_task"]; 
  
    if ( _task isEqualTo ( "task1" call BIS_fnc_taskReal ) ) then { 
        {//foreach start
            _x enableSimulation true;  
            _x hideObject true;  
        } forEach [getMissionLayerEntities "civis" select 0]  
    }
}];