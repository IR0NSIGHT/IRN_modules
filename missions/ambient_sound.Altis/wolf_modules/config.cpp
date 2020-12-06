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
		class Module_F: Logic
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

			class Arguments: AttributesBase
			{
				class debug
				{
					displayName = "debug mode";
					description = "0 = off, 1 = on";
					typeName = "NUMBER";
					defaultValue = "0";
				}

				class minDistance
				{
					displayName="minimum distance";
					description="minimum distance required to hear ambient sounds at full volume";
					typeName = "NUMBER";
					defaultValue="800";
				};

				class maxDistance
				{
					displayName="maximum distance";
					description="maximum distance ambient sounds are audible";
					typeName = "NUMBER";
					defaultValue="3000";
				};

				class salvoFrequency
				{
					displayName="salvo frequency";
					description="downtime between salvo cycles in seconds";
					typeName = "NUMBER";
					defaultValue="10";
				};

				class salvoAverage
				{
					displayName="Salvo average";
					description="amount of salvos spawned per cylce on average";
					typeName = "NUMBER";
					defaultValue="3";
				};

				class expAverage
				{
					displayName="Explosion probability";
					description="percent 0..1 of an explosion being spawned per cycle";
					typeName = "NUMBER";
					defaultValue="0.2";
				};

				class end
				{
					displayName = "end";
					description = "duration for the ambient battle to last in seconds";
					typeName = "NUMBER";
					defaultValue="600";
				};

				class tracersEveryX
				{
					displayName = "Tracers every -x- shots";
					description = "Spawn a tracer after every -x- shots in a salvo. Is overwritten by tracerpercentage.";
					typeName = "NUMBER";
					defaultValue="5";
				};

				class percentTracers
				{
					displayName = "Random chance of tracer";
					description = "Spawn a tracer with a chance of 0..1. 'Overwrites Tracers every -x- shots'";
					typeName = "NUMBER";
					defaultValue="0.2";
				};

				class tracersRndVec
				{
					displayName = "Give tracers random direction";
					description = "0: salvos will fire in the same direction (flak). 1: every tracer will have random direction.";
					typeName = "NUMBER";
					defaultValue="1";
				};

				class tracerColor
				{
					displayName = "Color palette for tracers";
					description = "Salvo colors are randomly selected from this list. format [r0..1,g0..1,b0..1]";
					typeName = "ArgTypeTEXT";
					defaultValue="[[1,0,0],[0,0,1]]";
				};

				class expColor
				{
					displayName = "Color palette for explosions";
					description = "Explosion colors are randomly selected from this list. format [r0..1,g0..1,b0..1]";
					typeName = "ArgTypeTEXT";
					defaultValue="[[1,1,0],[0,1,1]]";
				};

				class expSize
				{
					displayName = "Explosion light intensity";
					description = "Brightness of an explosion lighting up surroundings.";
					typeName = "NUMBER";
					defaultValue="0.5";
				};

				class expSounds
				{
					displayName = "List of explosion sounds";
					description = "List of filepaths to used explosion sounds.";
					typeName = "ArgTypeTEXT";
					defaultValue="[""A3\Sounds_F\weapons\Explosion\expl_big_1.wss"",""A3\Sounds_F\weapons\Explosion\expl_big_2.wss"",""A3\Sounds_F\weapons\Explosion\expl_big_3.wss""]";
				};

				class shots
				{
					displayName = "List of gun sounds";
					description = "List of filepaths to used gun sounds.";
					typeName = "ArgTypeTEXT";
					defaultValue="[""A3\Sounds_F\weapons\Explosion\expl_big_1.wss"",""A3\Sounds_F\weapons\Explosion\expl_big_2.wss"",""A3\Sounds_F\weapons\Explosion\expl_big_3.wss""]";
				};

                class ModuleDescription: ModuleDescription
                {
					displayName = "Description";
                    position = 1;
                    defaultValue = """Create an ambient fake-battle using audio and visual methods at the modules positon.""";
                };
			};

		};
	};