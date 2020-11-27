/**
input:
_speed : travelling speed in m/s
_distance: distance travelled in m

return:
_time : time required to travel
 */
params["_speed","_distance"];
_time = _distance / _speed;
//diag_log ["traveltime params: ", _this,"solution: ", _time];
_time
