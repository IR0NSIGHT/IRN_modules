//yourmenu.h = it defines the menu dialog (display in code above)

class sliderSingle
{
    type = 43;
    idc = #UNIQUE ID HERE#;
    x = safeZoneX + safeZoneW * 0.51875;
    y = safeZoneY + safeZoneH * 0.59111112;
    w = safeZoneW * 0.1625;
    h = safeZoneH * 0.03111112;
    style = 1024;
    arrowEmpty = "\A3\ui_f\data\GUI\Cfg\Slider\arrowEmpty_ca.paa";
    arrowFull = "\A3\ui_f\data\GUI\Cfg\Slider\arrowFull_ca.paa";
    border = "\A3\ui_f\data\GUI\Cfg\Slider\border_ca.paa";
    color[] = {0.8,0.8,0.8,1};
    colorActive[] = {1,1,1,1};
    thumb = "\A3\ui_f\data\GUI\Cfg\Slider\thumb_ca.paa";
    onLoad = "[] call #YOUR_INIT_FUNCTION_HERE#;";
    onSliderPosChanged = "[] call #YOUR_CHANGE_FUNCTION_HERE#;";
};

//yourchangefunction.sqf

disableSerialization;
private _slider = (findDisplay YOUR_DISPLAY_ID) displayCtrl YOUR_UNIQUE_ID_HERE;
private _myvalue = sliderPosition _slider;

//in config.cpp -> #include "description.h"
//in description.h -> 
#include "data\includes\yourmenu.h"
//you can also just include yourmenu.h directly, this is just from my personal examples

//display_id

class yourmenu
{
    idd = the_display_id;

//personal tip 

onLBSelChanged = "_this call your_function;";
//same for onload
//then you can straight up ignore your display idc and control idc
//it (your_function) will always know what you're talking about

//yourfunction can then listen for:

params [
    ["_control", controlNull, [controlNull]],
];

//fyi if you use this tip, you don't need disableSerialization;


https://community.bistudio.com/wiki/sliderSetRange //see additional information in the link at the bottom of the wiki 

