/**
stolen from dedmen 
thanks helpmen
*/
params["_pos"];
{ 
private _lamps =_pos nearObjects [_x, 5000]; //radius in metern, thisTrigger kann auch variablenname von objekt sein   
{_x setDamage 1} forEach _lamps; 
} foreach ["Lamps_Base_F","Land_PowerPoleWooden_F", "Land_LampHarbour_F", "Land_LampShabby_F", "Land_PowerPoleWooden_L_F", "Land_PowerPoleWooden_small_F", "Land_LampDecor_F", "Land_LampHalogen_F", "Land_LampSolar_F", "Land_LampStreet_small_F", "Land_LampStreet_F", "Land_LampAirport_F", "Land_PowerPoleWooden_L_F", "PowerLines_base_F"];

