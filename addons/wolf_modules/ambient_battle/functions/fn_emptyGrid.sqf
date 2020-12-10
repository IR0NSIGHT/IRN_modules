//get a grid with no player in it around center
// !! THIS FUNCTION IS IN DEV STAGE AND NOT READY TO BE USED !!
params ["_pos","_minDist","_maxDist"];
_pos = [5,5,0];
_minDist = 5;
_maxDist = 5;
_virPlayers = [[1,4,0],[6,7,0],[2,9,0],[9,5,0]];
//loop over all grid outwards, check for players in grid
_open = [];
_scale = 1;
for "_xP" from -_maxDist to _maxDist do { //++,+-,--,-+
	for "_yP" from -_maxDist to _maxDist do {
		//hint str [_xp,_yp];
		_gridP = [
			(_pos select 0) + _xP * _scale,
			(_pos select 1) + _yP * _scale,
			0
			];
		if ( (vectorMagnitude (_gridP vectorDiff _pos)) <= _maxDist) then {
			hint str ["adding: ",_gridP];
			_open pushBack _gridP;
		};
	};
};
systemchat str ["open array:",_open];
//created all available grids here
_run = true;
_minToPl = _scale * 1.4 * 1.5; //1.5 diagonal in grid
hint str ["minimum distance:",_minToPl];
while {_run} do {
	_grid = selectRandom _open;
	_open= _open - [_grid];
	hint str ["comparing: ",_grid];


	_skip = true;
	{
		
		//if theres players closer to gridcenter than allowed, jump to next grid.
		//(vectorMagnitude (_x vectorDiff _grid))
		_distToP = (vectorMagnitude (_x vectorDiff _grid));
		hint str ["comp against:",_x,"distance:",_distToP];
		if (_distToP <= _minDist) exitWith {
			hint str "to close";
			_skip = false;
			};
	} forEach _virPlayers;
	if (_skip) exitWith {
		_pos = _grid;
		};
	if (count _open == 0) exitWith {systemChat "error"};
};
systemChat str ["done with position:",_pos," left:",count _open];


	//get closest player
		//if griddiagonal * 1.5 > distToPlayer then use this grid, choose randomly inside it,
		//else move to next grid 