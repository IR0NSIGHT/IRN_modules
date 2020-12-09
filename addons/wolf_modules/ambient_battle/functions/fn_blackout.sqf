//ran from the blackout editor module

diag_log ["blackout module ran with:",_this];
if (_this select 0 != "init") exitWith {};
private ["_debug","_range","_chance","_logic","_pos","_i"];
_logic = _this select 1 select 0;
_debug = _logic getVariable ["debug",0];
if (_debug == 0) then {
	_debug = false;
} else {
	_debug = true;
};
_range = _logic getVariable ["range",1000];
_chance = _logic getVariable ["chance",1];
_pos = getPos _logic;
_i = 0;
{ 
	private _lamps =_pos nearObjects [_x, _range]; //radius in metern, thisTrigger kann auch variablenname von objekt sein   
	{_i = _i + 1;_x setDamage 1} forEach _lamps; 
} foreach ["Lamps_Base_F","Land_PowerPoleWooden_L_F", "Land_LampHarbour_F", "Land_LampShabby_F", "Land_PowerPoleWooden_L_F", "Land_PowerPoleWooden_small_F", "Land_LampDecor_F", "Land_LampHalogen_F", "Land_LampSolar_F", "Land_LampStreet_small_F", "Land_LampStreet_F", "Land_LampAirport_F", "Land_PowerPoleWooden_L_F", "PowerLines_base_F"];
if (_debug) then 
{
	diag_log ["blackout module at ",_pos,"killed",_i,"lights"];
};
//[5774.35,10203.4,0]