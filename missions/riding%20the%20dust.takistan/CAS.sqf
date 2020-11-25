
_listToSay = _this;
convoiLeader kbTell [
	player,										// to
	"DynamicSay",								// topic
	"DynamicSay",							// sentence
	["List", {}, "", _listToSay],			// argument 1
//	["List", {}, "hallo", ["one"]],			// argument 1
	true
];