//plays sitrep from JTAC for all CA planes
_sounds = [];
//sitrep
_sounds pushBack "sitRep";
//threat activity 
_sounds pushBack "threatManpads";
//target general enemy situation 
_sounds pushBack "targetInf";
//friendly situation 
_sounds pushBack "friendliesConvoi";
//artilley act 
_sounds pushBack "b_artyNone";
//clearance 
_sounds pushBack "clearanceJTAC";
//restrictions
_sounds pushBack "restrictionsCivProtect";
_sounds pushBack "sk8ter";
_sounds pushBack "out";
sleep 10;
{
	player sideRadio _x;
	sleep 0.5;
} foreach _sounds;
