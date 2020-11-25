player kbAddTopic ["DynamicSay", "Conversation.bikb"];
//dude_01 kbAddTopic ["AirstrikeRequest","Conversation.bikb"];
_listToSay = [
	"RequestAccomplishedSGCASBombing","__4","WeaponsFree","CombatOpenFire"
];
_enemiesNear = ["SuppressiveFire","Safe","Contact","Confirmation1","Nazari","veh_vehicle_truck_p","CancelTarget","lima", "Safe","GenReinforcementsConfirmed1","Bombs","reportFront","veh_infantry_p","dist500","northEast","RequestingSupportS","ScanHorizon","SupportRequestRGCASBombing","RequestAcknowledgedSGCASBombing","UnitDestroyedHQCASBombing"];
//ExplosiveDetected

//we got enemies 500m north
//free to engage
//hold fire
//no targets
//convoi is stopping
//convoi advancing
_listToSay = [
"SupportRequestRGCASBombing","dist500","northEast","veh_infantry_p"
];
_escort = ["AreaClear","CeaseFire","GenCmdTargetEscort"];
_listToSay = _escort;
player kbTell [
	player,										// to
	"DynamicSay",								// topic
	"DynamicSay",							// sentence
	["List", {}, "hallo", _listToSay],			// argument 1
//	["List", {}, "hallo", ["one"]],			// argument 1
	true
];