if (didJIP) exitWith {};
_cam = "camera" camCreate [1521,1278,34];
_cam cameraEffect ["internal", "BACK"];
sleep 16;
1 fadeSound 0;
CutText ["","Black out", 0];
titleText ["Der, der weiß, wann er kämpfen sollte und wann nicht, wird siegreich sein.", "Plain", 2];
sleep 10;
titleText ["Malex Ason", "Plain", 2];
sleep 7;
titleText ["Operation Withering Dusk", "Plain", 2];
sleep 3;
CutText ["","Black in", 0];

_cam CameraEffect ["Terminate","back"];
CamDestroy _cam;
5 fadeSound 1;

scriptDone introSeq;