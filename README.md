# Ambient battle and blackout modules
this mod contains two editor modules for arma 3:
- Ambient battle
- Blackout

## Ambient battle
Ambient  battle creates a fake battle at its position through spawning shot sounds, tracer bullets and explosion lights and sounds. The sounds are audible at any distance (configurable in options). Sounds take the correct amount of time to travel from source to player, all visual and audio effects are synched between players. Network traffic is reduced as much as possible. 
The module is highly configurable, from amount of shots over time, to color of tracers and explosions to soundfiles used. 
The modules settings can be accessed from outside during runtime, by using yourLogicModule setVariable ["varname",value];. the next iteration will run with the new settings.

Ambient Battle is trigger activated.

### issues:
- lights/tracers might not be visible during day
- lights/tracers might not be visible in heavily illuminated areas or from far away (light engine problem). Easy fix is to use "Blackout" to kill all lights.
- tracers might not work in a dedicated server Multiplayer environment. cause is unknown.

## Blackout
core code provided by Dedmen. Will kill (almost) all lights in specified radius. trigger activated.

### issues:
- unknown streetlight classes will be ignored
- tanoa powerline pole lamps survive
- some lights like gasstation and hospital cant be killed
- unknown behaviour for JIP players
## Usage
You are allowed to use this work according to the attached license.

## Contributors
- Code:
IR0NSIGHT
Dedmen
- support:
KiritoKun
AlexMason
arma3 community
