# Ambient battle and blackout modules
this mod contains two editor modules for arma 3:
- Ambient battle
- Blackout

## Ambient battle:
Ambient  battle creates a fake battle at its position through spawning shot sounds, tracer bullets and explosion lights and sounds. The sounds are audible at any distance (configurable in options). Sounds take the correct amount of time to travel from source to player, all visual and audio effects are synched between players. Network traffic is reduced as much as possible. 
The module is highly configurable, from amount of shots over time, to color of tracers and explosions to soundfiles used. 
The modules settings can be accessed from outside during runtime, by using yourLogicModule setVariable ["varname",value];. the next iteration will run with the new settings.

Ambient Battle is trigger activated.

## Blackout
core code made by Dedmen. Will kill (almost) all lights in specified radius. trigger activated. Known exceptions are the Tanoa streetlights that hang on powerline-poles.
