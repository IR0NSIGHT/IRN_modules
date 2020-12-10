# TODO list
# Ambient battle
## clean up and document code
- get rid of obsolete functions
- separate blackout and ambient battle code
- clean up setting inputs for ambBattle 
    - maybe move big inputs away from module (sound files)?
    - add checkbox for boolean inputs (debug)
    - add a readable documentation for what input does what
    - figure out what minDistance was intended for

## hotfixes
- make sounds less loud
- fix distance based loudness once and forall
- test (and fix) tracers on dedicated
- make spawnSalvo use maxDistance

## wanted features
### add ability for close-by fakebattles
Ambient battles holds potential for creating ambient background also in close proximity. Requirement is an obstructed line of sight, so no open grounds. But city or wooded areas should work fine. 
Only addition needed atm:
Fire effects only at positions that are a x minimum distance away from the player. 
- fn_emptyGrid is the core function. needs finish and testing.
- have any random position selection for sound/effects test if player is closeby/find an empty spot

### add "use default if left blank" option for user input


# Blackout
## clean up and document code
- better docu for function

## wanted features
### add synchronized flickering lights
- use random chance to leave some lights alive, flickering synchronized on all machines.
    - global serverside loop with remoteexec setDamage 0 sleep 1 or use a sinus function to run without network but remain synchro on clients?
    - central loop for all lights or each light gets loop?
    - test performance before implementing ANY loops!!
