//spawn a bullet global, attach lights to it on each client
//fnc_spawnTracer: 
params["_vector","_color","_pos"];
diag_log ["################################# fnc_spawnTracer called with: ",["_vector","_color"],_this];

private _bullet = "B_408_Ball" createVehicle _pos;
_bullet setVelocity _vector;

//spawn a client local light on each clientOwner
[_bullet,_color] remoteExec ["IRN_fnc_spawnTracerLight",0];
