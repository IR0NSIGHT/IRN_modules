class CfgFunctions
{
	class IRN //my tag class
	{
        class myCategory {
            class calcSoundPos {file = "WOLF_Modules\ambient_battle\functions\fn_calcSoundPos.sqf";};
			class testFunction  {file = "WOLF_Modules\ambient_battle\functions\fn_test.sqf";};
            class spawnSalvo {file = "WOLF_Modules\ambient_battle\functions\fn_spawnSalvo.sqf"};
			class spawnTracer {file = "WOLF_Modules\ambient_battle\functions\fn_spawnTracer.sqf"};
			class randomVector {file = "WOLF_Modules\ambient_battle\functions\fn_randomVector.sqf"};
			class explosionLight {file = "WOLF_Modules\ambient_battle\functions\fn_explosionLight.sqf"};
			class killLights {file = "WOLF_Modules\ambient_battle\functions\fn_killLights.sqf"};
			class interpolate {file = "WOLF_Modules\ambient_battle\functions\fn_interpolate.sqf"};
			class travelTime {file = "WOLF_Modules\ambient_battle\functions\fn_travelTime.sqf"};
			class delayedSound {file = "WOLF_Modules\ambient_battle\functions\fn_delayedSound.sqf"};
			class spawnTracerLight {file = "WOLF_Modules\ambient_battle\functions\fn_spawnTracerLight.sqf"};
			class remoteSalvo {file = "WOLF_Modules\ambient_battle\functions\fn_remoteSalvo.sqf"};
			class initAmbBattle {file = "WOLF_Modules\ambient_battle\functions\fn_initAmbBattle.sqf"};
        };
    };
};

class CfgPatches
{
	class IRN_ambientBattle
	{
		units[] = {"ModuleAmbientBattles"};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F"};
	};
};

class CfgVehicles 
	{
        class Logic;
		class Module_F: Logic;
        {
            class AttributesBase
            {
                class Default;
                class Edit;					// Default edit box (i.e., text input field)
                class Combo;				// Default combo box (i.e., drop-down menu)
                class Checkbox;				// Default checkbox (returned value is Boolean)
                class CheckboxNumber;		// Default checkbox (returned value is Number)
                class ModuleDescription;	// Module description
                class Units;				// Selection of units on which the module is applied
            };
            class ModuleDescription;
        };

		class ModuleAmbientBattles: Module_F
		{
			author = "IR0NSIGHT";
			_generalMacro = "ModuleAmbientBattles";
			scope = 2; //editor visibility
			icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
			portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
			displayName = "Ambient Battles";
			category = "Effects";

            // Name of function triggered once conditions are met
			function = "IRN_fnc_initAmbBattle";

            // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		    isGlobal = 0;

            // 1 for module waiting until all synced triggers are activated
		    isTriggerActivated = 1;

            // 1 if modules is to be disabled once it is activated (i.e., repeated trigger activation won't work)
		    isDisposable = 1;

            // 1 to run init function in Eden Editor as well
            is3DEN = 1;

            // Menu displayed when the module is placed or double-clicked on by Zeus
            curatorInfoType = "RscDisplayAttributeModuleAmbientBattles";

			class Attributes: AttributesBase
			{
				class MyText: Edit
				{
					displayName = "a test text attribute";
					description = "the lord yeeteth and the lord yoinketh. (Lunchbreak 11:10)";
                    tooltip = "in the name of our overlord IR0NSIGHT";
                    defaultValue = """Im a text.""";
				};
				class duration
				{
					displayName = "Duration";
					description = "Duration of Sounds in Minutes";
					class values
					{                  
						class 1
                        {
                            name = "1 minute";
                            value = "60";
                            default = 1;
                        };                      
					};
				};
				class maxdistance
				{
					displayName = "Maximum distance";
					description = "Maximum distance to the module to play sound for the player. If player exceeds the range the sound will be stopped.";
					class values
					{                  
                        class 3000
                        {
                            name = "3000 meters";
                            value = "3000";
                            default = 1; 
                        };
					};
				};
                class ModuleDescription: ModuleDescription
                {
                    position = 1;
                    description = "Create ambient battle sounds. Sound center is module position.";
                };
			};

		};
	};