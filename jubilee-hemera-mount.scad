// choose which parts to print, only choose one at a time for printing
// this does not worry about if the parts are sitting at 0 height since slicer will set them on the bed
needHemera       = false;
needHemeraStl    = false;
needTop          = true;
flipTop          = true;   // flip, by setting to true, for printing without supports
needDuct         = false; 
needCableSupport = false;
needORingSupport = false;
needToolplate    = false;
needAdapter      = false;

// hemera measurements - all from looking at the front of the extruder

hLen = 76.75;                    // outside-to-outside, not from screw
hWth = 44.0;
hHt = 40;                        // approx, not including hot end and top stuff
hXBoltDiff = 34;                 // distance between screws in X
hYBoltDiff = 34;                 // distance between screws in Y
hXBolt1Off = hLen-3-hXBoltDiff;
hXBolt2Off = hLen-3;
hNozX = 73.75 - 48.25;           // from right side screw
hNozY = 28.9;                    // from front to nozzle center
hNozZ = 24.2;                    // from bottom screw
hNozBellowBlk = 4.3;             // approx
hEFanThk = 10;
hECoolVaneThk = 10;
hBoltMountThk = 5;
hBoltSize = 3;
hBoltNutSize = 3;
hBoltHeadSize = 8;                // allow for a little extra space

//heater block

hBlkLen = 23;
hBlkWth = 16;
hBlkHt = 11.5;
hBlkNozLenOff = 8;                // Behind nozzle as looking from front

// post constants

postAboveTopScr = 31;//27;//30;
postSlideDia = 7;  
postDia = 5;
postSeperation = 55;
postZ = hNozZ+hYBoltDiff+postAboveTopScr;
postLeftX = hXBolt1Off-postSeperation/2-9+30/2;
postRightX = postLeftX + postSeperation;

// top constants
topExtraAroundPost = 4;
topThk = postSlideDia/2 + topExtraAroundPost;
attachBoltSize = 3;
attachBoltNutSize = 6.1;
attachBoltHeadSize = 8;  // allow for a little extra space
attachLen = 9;
attachThk = 6;
attachWth = attachBoltHeadSize + 2;
hAdapterThk = 7.5;
toolPlateBoltZBelowPin = 17; //13;//18;
hToolPlateLeftBoltX = hXBolt1Off-8;
hToolPlateLeftBoltZ = postZ - toolPlateBoltZBelowPin;
hToolPlateRightBoltX = hToolPlateLeftBoltX + 30 - 2.3;
hToolPlateRightBoltZ = postZ - toolPlateBoltZBelowPin;
toolPlateAttachLen = toolPlateBoltZBelowPin + 5;
hTubeFromToolPlateY = 25;

// fan constants

fanOutX = 19.5;
fanOutY = 15.5;
fanWth = 51;
fanHt = 51;
fanBoltSize = 4;

// Duct constants 

ductBlkOffset = 8;
lineWth = 0.4;
wallWth = 3*lineWth;
rndEdgeRad = 1;
transHt = 20;
htAboveTopScrTran1 = postAboveTopScr + topThk-transHt;
w1 = hXBoltDiff - hBoltHeadSize - wallWth*2-3;// allow for a little extra space
d1 = 4;
manHt = hBlkHt - wallWth*2;
manWth  = (w1*d1/manHt);
manLen = ((hXBolt1Off+hXBolt2Off)/2 + w1/2) - (hNozX-hBlkWth/2-ductBlkOffset - manWth - wallWth*2);
nozDuctWth = manWth/2;
l1 = hNozZ - (hNozBellowBlk+manHt+wallWth) + hYBoltDiff + htAboveTopScrTran1;
nozDuctPastNoz = 3;
ductVertCenterX = (hXBolt1Off+hXBolt2Off)/2;
ductVertInsideXLeft = ductVertCenterX + w1/2;
ductVertInsideXRight = ductVertCenterX - w1/2;

// cable support constants
supportWth=20;
supportHt=51;
supportThk=3;
supportXLeft = ductVertCenterX - supportWth/2 - 2;
supportXRight = ductVertCenterX + supportWth/2 -2 ;
supportYFront = -d1+fanOutY;
supportZ = postZ + topThk;
supportBoltSize = 4;
supportBoltNutSize = 8;

// o-ring constants
ringOD = 9;
ringID = 5;
ringDia = 2;
ringBoltSize = 3;
ringBoltNutSize = 6.1;
ringBoltOff = 1;

// toolplate wedge spacer constants
wTopTo2ndHoleSpacing = 14;
w2ndTo3rdHoleSpacing = 14;
w3rdTo4thHoleSpacing = 22.5;
wSlotAbove3rdHole = 18;
if(needORingSupport) {
     difference() {
	  cylinder(d=ringOD-ringDia, h=postSlideDia, $fa=2, $fs=.1);

	  // remove the area where the o-ring goes
	  translate([0, 0, postSlideDia/2])
	       rotate_extrude(angle=360, convexity=2, $fa=2, $fs=.1) translate([(ringID+ringDia)/2, 0, 0])circle(d=ringDia, $fa=2, $fs=.1);

	  // create bolt hole
	  translate([ringBoltOff, 0, 0]) cylinder(d=ringBoltSize, h=postSlideDia, $fa=2, $fs=.1);
     }
}

if (needDuct) {
     fanDuctEntZ = transHt+hNozBellowBlk+manHt+wallWth+l1;
     // draw ducting for fan to nozzle
     difference () {

	  // draw housing, offset from ducts to have ducts removed internally properly
	  union() {
	       minkowski() {
		    drawDucts(holes=false);

		    // add wallWth to create shell thickness
		    sphere(r=rndEdgeRad+wallWth);  
	       }

	       // draw housing of fan entrance
	       translate([ductVertInsideXLeft - fanOutX-wallWth, -d1-wallWth*3, fanDuctEntZ])
		    cube([fanOutX+wallWth*2, fanOutY+wallWth*2, 4]);
	  }
	  
	  // draw ducts, within the housing
	  minkowski() {
	       drawDucts(holes = true);
	       sphere(r=rndEdgeRad);
	  }
	  
	  //draw fan entrance to ducts
	  translate([ductVertInsideXLeft - fanOutX, -d1-wallWth*2, fanDuctEntZ-.1])
	       cube([fanOutX, fanOutY, 4.2]);
	  translate([ductVertInsideXLeft - fanOutX-2, -d1-wallWth*2+fanOutY/2-1, fanDuctEntZ-.1])
	       cube([5, 2, 5]);
     }
     
     drawDuctAttachments();	    
}

// draw top shelf
topAng = flipTop?180:0;
if (needTop) rotate([topAng, 0, 0]){
     postConeLength=10;
     difference() {
	  union() {

	       // main top plate
	       translate([postLeftX-attachThk-postSlideDia/1.2+topExtraAroundPost/2, 0, postZ])
		    cube([postSeperation+topExtraAroundPost+postSlideDia/1.2+attachThk+attachWth, hWth+hAdapterThk, topThk]);

	       // left wall for round riders
	       translate([postLeftX+postSlideDia/2, hWth*.75, postZ-ringOD-postDia/2])
		    cube([attachThk, hWth*.25+hAdapterThk, ringOD+postDia/2]);
//	       translate([postLeftX-postSlideDia/2-attachThk, supportYFront, postZ-ringOD-postDia/2])
//		    cube([attachThk, hWth+hAdapterThk-supportYFront, ringOD+postDia/2]);

	       // right wall for round riders
	       translate([postRightX-postSlideDia/2-attachThk, hWth*.75, postZ-ringOD-postDia/2])
		    cube([attachThk, hWth*.25+hAdapterThk, ringOD+postDia/2]);
//	       translate([postRightX-postSlideDia/2-attachThk, supportYFront, postZ-ringOD-postDia/2])
//		    cube([attachThk, hWth+hAdapterThk-supportYFront, ringOD+postDia/2]);

	       // draw left front attachment
	       translate([postLeftX+postSlideDia/1.2, 0, postZ-attachLen])
		    cube([attachWth, attachThk, attachLen]);
	       
	       // draw right front attachment
	       translate([postRightX+postSlideDia/1.2, 0, postZ-attachLen])
		    cube([attachWth, attachThk, attachLen]);

	       // draw left back attachment
	       translate([hToolPlateLeftBoltX - attachWth/2, hWth+hAdapterThk-attachThk, postZ-toolPlateAttachLen])
		    cube([attachWth, attachThk, toolPlateAttachLen]);
	       
	       // draw right back attachment
	       translate([hToolPlateRightBoltX - attachWth/2, hWth+hAdapterThk-attachThk, postZ-toolPlateAttachLen])
		    cube([attachWth, attachThk, toolPlateAttachLen]);

	       // draw back attachment reenforcement
	       translate([postLeftX+postSlideDia/2, hWth+hAdapterThk-attachThk, postZ-ringOD-postDia/2])
		    cube([postSeperation-postSlideDia, attachThk/2, ringOD+postDia/2]);
	       
	  }

	  // draw left front attachment hole for bolt and nut
	  translate([postLeftX+attachWth/2+postSlideDia/1.2, attachThk, postZ-hBoltSize])
	       rotate([90, 0, 0]) drawBoltNutHole(attachBoltSize, attachBoltNutSize, attachThk);

	  // draw right front attachment hole for bolt and nut
	  translate([postRightX+attachWth/2+postSlideDia/1.2, attachThk, postZ-hBoltSize])
	       rotate([90, 0, 0]) drawBoltNutHole(attachBoltSize, attachBoltNutSize, attachThk);

	  // draw left back attachment hole for bolt and nut
	  translate([hToolPlateLeftBoltX, hWth+hAdapterThk-attachThk, hToolPlateLeftBoltZ])
	       rotate([-90, 0, 0]) drawBoltNutHole(attachBoltSize, attachBoltNutSize, attachThk);

	  // draw right back attachment hole for bolt and nut
	  translate([hToolPlateRightBoltX, hWth+hAdapterThk-attachThk, hToolPlateRightBoltZ])
	       rotate([-90, 0, 0]) drawBoltNutHole(attachBoltSize, attachBoltNutSize, attachThk);

          // draw slots for pins
	  translate([postLeftX, 0, postZ-2])
	       rotate([-90, 0, 0]) drawSlot(postSlideDia, 4, hWth+hAdapterThk+.1);
	  translate([postRightX, 0, postZ])
	       rotate([-90, 0, 0]) cylinder(d=postSlideDia, h=hWth+hAdapterThk+.1, $fa=2, $fs=.1);

	  // for slots for pin offer wide entrance

	  translate([postLeftX, -.1, postZ])
	       rotate([-90, 0, 0]) cylinder(r1=postSlideDia/1.2, r2=postSlideDia/2, h=postConeLength+.1, $fa=2, $fs=.1);
	  translate([postRightX, -.1, postZ])
	       rotate([-90, 0, 0]) cylinder(r1=postSlideDia/1.2, r2=postSlideDia/2, h=postConeLength+.1, $fa=2, $fs=.1);
	  
	  // draw slot to go around duct opening  
	  translate([ductVertInsideXLeft - fanOutX-wallWth*2, -d1-wallWth, postZ-.1])
	       cube([fanOutX+wallWth*4, fanOutY+wallWth, topThk+.2]);

	  // draw cable hole  
	  translate([supportXLeft+12+supportThk, -d1+fanOutY-.1, postZ-.1])
	       cube([supportWth-supportThk*3.5, supportThk*5+.1, topThk+.2]);

	  // holes for bolts to attach support to top.  
	  translate([supportXLeft+12-supportBoltSize, supportYFront+supportThk+supportBoltSize, postZ])
	       rotate([0, 0, 30]) drawBoltNutHole(supportBoltSize, supportBoltNutSize, topThk);
	  translate([supportXLeft+12-supportBoltSize, supportYFront+supportThk*4+10-supportBoltSize, postZ])
	       rotate([0, 0, 30]) drawBoltNutHole(supportBoltSize, supportBoltNutSize, topThk);
	  translate([supportXLeft+supportWth+23-supportBoltSize, supportYFront+supportBoltSize, postZ])
	       rotate([0, 0, 30]) drawBoltNutHole(supportBoltSize, supportBoltNutSize, topThk);
	  translate([supportXLeft+supportWth+23-supportBoltSize, supportYFront+supportThk*4+10-supportBoltSize, postZ])
	       rotate([0, 0, 30]) drawBoltNutHole(supportBoltSize, supportBoltNutSize, topThk);

	  // make a hole so the tube/filament is not constrained coming out of the top of the hemera
	  // using slot to make sure it is just a U shape but have to subtract off half of the "seperation" to make sure U is centered on tube
//	  translate([hNozX+9, hWth+hAdapterThk-hTubeFromToolPlateY, postZ-.1])
//	       rotate([0, 0, 0]) drawSlot(22, 10, topThk+.2);	  
	  translate([postLeftX+postSlideDia/2+.5, attachThk*1.5, postZ-.1])
	       cube([21, hWth*.75-attachThk*1.5, topThk+.2]);
	  
	  // bolt holes in left wall for round riders
//	  translate([postLeftX+postSlideDia/2+attachThk*2, supportYFront+ringOD/2, postZ+postSlideDia/2-postDia-ringOD/2])
//	       rotate([0, -90, 0]) drawBoltNutHole(ringBoltSize, ringBoltNutSize, attachThk);
	  translate([postLeftX+postSlideDia/2+attachThk, hWth+hAdapterThk-attachThk-ringOD/2-2, postZ+postSlideDia/2-postDia-ringOD/2])
	       rotate([0, -90, 0]) drawBoltNutHole(ringBoltSize, ringBoltNutSize, attachThk);

	  // bolt holes in right wall for round riders
//	  translate([postRightX-postSlideDia/2-attachThk, supportYFront+ringOD/2, postZ+postSlideDia/2-postDia-ringOD/2])
//	       rotate([0, 90, 0]) drawBoltNutHole(ringBoltSize, ringBoltNutSize, attachThk);
	  translate([postRightX-postSlideDia/2-attachThk, hWth+hAdapterThk-attachThk-ringOD/2-2, postZ+postSlideDia/2-postDia-ringOD/2])
	       rotate([0, 90, 0]) drawBoltNutHole(ringBoltSize, ringBoltNutSize, attachThk);
     }
}

// draw cable support
if (needCableSupport) {
     
     // base
     difference() {
	  translate([supportXLeft+4, supportYFront, transHt+hNozBellowBlk+manHt+wallWth+l1])
	       cube([supportWth+20, supportThk*4+10, supportThk]);
	  
	  // draw cable hole
	  translate([supportXLeft+12+supportThk, supportYFront-.1, postZ+topThk-.1])
	       cube([supportWth-supportThk*3.5, supportThk*5+.1, topThk+.2]);

	  // holes for bolts to attach to top
	  translate([supportXLeft+12-supportBoltSize, supportYFront+supportThk+supportBoltSize, supportZ-.1])
	       cylinder(d=supportBoltSize, h=supportThk+.2, $fa=2, $fs=.1);
	  translate([supportXLeft+12-supportBoltSize, supportYFront+supportThk*4+10-supportBoltSize, supportZ-.1])
	       cylinder(d=supportBoltSize, h=supportThk+.2, $fa=2, $fs=.1);
	  translate([supportXLeft+supportWth+23-supportBoltSize, supportYFront+supportBoltSize, supportZ-.1])
	       cylinder(d=supportBoltSize, h=supportThk+.2, $fa=2, $fs=.1);
	  translate([supportXLeft+supportWth+23-supportBoltSize, supportYFront+supportThk*4+10-supportBoltSize, supportZ-.1])
	       cylinder(d=supportBoltSize, h=supportThk+.2, $fa=2, $fs=.1);
     }

     // upright U
     translate([supportXLeft+12, supportYFront+supportThk*6, supportZ+supportThk])
	  cube([supportWth, supportThk, supportHt]);
     difference() {
	  translate([supportXLeft+12, supportYFront+supportThk, supportZ+supportThk])
	       cube([supportThk, supportThk*6, supportHt]);

	  // zip tie holes
	  translate([supportXLeft+12-.1, supportYFront+supportThk*1.5, supportZ+supportThk+5])
	       rotate([-90, 0, -90]) drawSlot(3, 6);
	  translate([supportXLeft+12-.1, supportYFront+supportThk*1.5, supportZ+supportHt-10])
	       rotate([-90, 0, -90]) drawSlot(3, 6);
     }
     translate([supportXRight - supportThk+12, supportYFront+supportThk*2, supportZ+supportThk])
	  cube([supportThk, supportThk*4, supportHt]);

     // fan bolt holder
     difference() {
	  translate([supportXLeft, supportYFront, supportZ])
	       cube([supportThk+12, supportThk, fanHt+supportThk]);
	  translate([ductVertInsideXLeft - fanOutX + 2, supportYFront-.1, supportZ+supportThk+fanHt-10])
	       rotate([-90, 0, 0])drawSlot(fanBoltSize, 8);
     }
}
     
module drawSlot(size=3, seperation=6, depth=10) {
     hull() {
	  translate([0, -seperation/2, 0]) cylinder(d=size, h=depth, $fa=2, $fs=.1);
	  translate([0, seperation/2, 0]) cylinder(d=size, h=depth, $fa=2, $fs=.1);
     }
}

// draw a slot with a bigger slot for the head.  Roundoff errors sometimes leave a little room on bolt hole so compensate
module drawBoltSlot(boltSize=3, boltSeperation=6, depth=5, headDepth=5) {
     translate([0, 0, -.1]) {
	  drawSlot(boltSize*2.2, boltSeperation, headDepth+.1);
	  drawSlot(boltSize, boltSeperation, depth+.2);
     }
}

// draw a bolt and nut combination.  Roundoff errors sometimes leave a little room on bolt hole so compensate
module drawBoltNutHole(boltSize=3, nutSize=6.1, depth=5) {
     translate([0, 0, -.1]) {
	  cylinder(d=boltSize, h=depth+.2, $fa=2, $fs=.1);
	  cylinder(d=nutSize, h=boltSize*.8+.2, $fn=6);
     }
}

module drawDucts(holes=true) {
     drawLowerDuct();
     drawUpperDuct();
     drawLeftNozzelDuct(holes);
     drawRightNozzelDuct(holes);
     drawFanDuct();
}

// lower duct

module drawLowerDuct() {
     translate([hNozX-hBlkWth/2-ductBlkOffset-manWth-wallWth*2, -d1-wallWth*2, hNozBellowBlk+wallWth]) {
	  cube([manLen, manWth, manHt]);
     }
}

// upper Duct

module drawUpperDuct() {
     translate([ductVertInsideXRight, -d1-wallWth*2, hNozBellowBlk+manHt+wallWth]) {
	       cube([w1, d1, l1]);
     }
}

// fan duct

module drawFanDuct() {
     w3 = w1;
     d3 = d1;
     l3 = transHt;
     translate([ductVertInsideXRight, -d1+d3-wallWth*2, hNozBellowBlk+manHt+wallWth+l1]) rotate([90, 0, 0]) {
	  fanDuctPoints = [
	       [         0,   0,           0 ],  //0
	       [        w3,   0,           0 ],  //1
	       [        w3,  l3,  d3-fanOutY ],  //2
	       [w3-fanOutX,  l3,  d3-fanOutY ],  //3
	       [         0,   0,          d3 ],  //4
	       [        w3,   0,          d3 ],  //5
	       [        w3,  l3,          d3 ],  //6
	       [w3-fanOutX,  l3,          d3 ]]; //7
	  
	  fanDuctFaces = [
	       [0,1,2,3],  // bottom
	       [4,5,1,0],  // front
	       [7,6,5,4],  // top
	       [5,6,2,1],  // right
	       [6,7,3,2],  // back
	       [7,4,0,3]]; // left
	  
	       polyhedron(fanDuctPoints, fanDuctFaces );
     }
}


// nozzel Duct

module drawNozzelDuct(hole=true) {
     w2 = manWth;
     w2a = manWth*.7;
     d2 = manHt-.1; // if .1 is not removed creates cgal error - not sure why
     d2a = manHt*.6;
     d2b = manHt*.2;
     l2 = hNozY;
     
     ductPoints = [
	  [  0,   0,   0  ],  //0
	  [ w2,   0,   0  ],  //1
	  [ w2,  l2,   0  ],  //2
	  [w2a,  l2,   0  ],  //3
  	  [  0,   0,  d2  ],  //4
	  [ w2,   0,  d2  ],  //5
	  [ w2,  l2,  d2b ],  //6
	  [w2a,  l2,  d2a ]]; //7

  ductFaces = [
	  [0,1,2,3],  // bottom
	  [4,5,1,0],  // front
	  [7,6,5,4],  // top
	  [5,6,2,1],  // right
	  [6,7,3,2],  // back
	  [7,4,0,3]]; // left

     polyhedron(ductPoints, ductFaces );
     if (hole) translate([w2+2, hNozY-8, -2]) rotate([0, -45, 0]) scale([0.1, 1, 1]) cylinder(h=5, r=w1/5);
}

// left nozzel Duct

module drawLeftNozzelDuct(hole=true) {
     translate([hNozX-hBlkWth/2-ductBlkOffset-manWth-wallWth*2, manWth-d1-wallWth, hNozBellowBlk+wallWth]) {
	  drawNozzelDuct(hole);
     }
}

// right nozzel Duct

module drawRightNozzelDuct(hole=true) {
     translate([hNozX+hBlkWth/2+ductBlkOffset+manWth+wallWth*2, manWth-d1-wallWth, hNozBellowBlk+wallWth]) {
	  mirror([1, 0, 0]) drawNozzelDuct(hole);
     }
}

// draw the duct attachments without holes
module drawDuctAttachments() {
     // draw duct attachment right
     difference() {
	  union() {
	       difference() {
		    translate([ductVertInsideXLeft + wallWth, -attachThk, hNozZ-attachBoltHeadSize/2-wallWth-attachWth*1.5])
			 cube([wallWth*2+attachWth, attachThk, l1+attachWth*1.5]);
		    translate([ductVertInsideXLeft + wallWth*2 + attachWth*1.5, -attachThk-.1, hNozZ-attachBoltHeadSize/2-wallWth-attachWth*1.5])
			 rotate([-90, 0, 0]) cylinder(r=wallWth+attachWth*1.5, h=attachThk+.2, $fa=2, $fs=.1);
		    translate([ductVertInsideXLeft + wallWth*2 + attachWth*.5, -attachThk-.1, l1+ hNozZ-attachBoltHeadSize/2-wallWth+3])
			 rotate([-90, 0, 0]) cylinder(r=wallWth+attachWth/2, h=attachThk+.2, $fa=2, $fs=.1);
	       }
	       difference() {		    
		    translate([postRightX+postSlideDia/1.2, -attachThk, hNozZ+hYBoltDiff])
			 cube([attachWth, attachThk, postAboveTopScr+topThk]);
		    translate([postRightX+attachWth*1.9+postSlideDia/1.2, -attachThk-.1, hNozZ+hYBoltDiff])
			 rotate([-90, 0, 0]) cylinder(r=attachWth*2, h=attachThk+.2, $fa=2, $fs=.1);
	       }
	  }

	  // make right holes for hemera bolts
	  translate([hXBolt2Off, -attachThk, hNozZ])
	       rotate([-90, 0, 0]) drawBoltSlot(hBoltSize, 5, attachThk, attachThk - hBoltMountThk);
	  translate([hXBolt2Off, -attachThk, hNozZ + hYBoltDiff])
	       rotate([-90, 0, 0]) drawBoltSlot(hBoltSize, 5, attachThk, attachThk - hBoltMountThk);
     
	  // make right hole for top mount bolts
	  translate([postRightX+attachWth/2+postSlideDia/1.2, -attachThk, postZ-hBoltSize])
	       rotate([-90, 0, 0]) drawBoltSlot(attachBoltSize, 5, attachThk, attachThk/2);
     }

     // draw duct attachment left
     difference() {
	  union() {
	       translate([ductVertInsideXRight - attachWth - wallWth, -attachThk, hNozBellowBlk+manHt+wallWth]) 
		    cube([attachWth, attachThk, l1+attachWth]);
	       difference() {		    
		    translate([postLeftX+postSlideDia/1.2, -attachThk, hNozZ+hYBoltDiff])
			 cube([attachWth*1.2, attachThk, postAboveTopScr+topThk]);
		    translate([postLeftX-attachWth+postSlideDia/1.2+2, -attachThk-.1, hNozZ+hYBoltDiff])
			 rotate([-90, 0, 0]) cylinder(r=attachWth*2, h=attachThk+.2, $fa=2, $fs=.1);
	       }
	  }

	  //hole to reduce weight
	  translate([ductVertInsideXRight - attachWth/2-wallWth, -attachThk-.1, postZ])
	       rotate([-90, 0, 0])drawSlot(attachWth, 15, attachThk+.2);
		    
	  // make left holes for hemera mount bolts 
	  translate([hXBolt1Off, -attachThk, hNozZ])
	       rotate([-90, 0, 0]) drawBoltSlot(hBoltSize, 5, attachThk, attachThk - hBoltMountThk);
	  translate([hXBolt1Off, -attachThk, hNozZ + hYBoltDiff])
	       rotate([-90, 0, 0]) drawBoltSlot(hBoltSize, 5, attachThk, attachThk - hBoltMountThk);

	  // make left hole for top mount bolts
	  translate([postLeftX+attachWth/2+postSlideDia/1.2, -attachThk, postZ-hBoltSize])
	       rotate([-90, 0, 0]) drawBoltSlot(attachBoltSize, 5, attachThk, attachThk/2);
      }
}

if (needToolplate) {
     tpWidth = hToolPlateRightBoltX - hToolPlateLeftBoltX + 20;
     tpHeight = 10+wTopTo2ndHoleSpacing+w2ndTo3rdHoleSpacing+w3rdTo4thHoleSpacing+10;

     difference() {

	  union() {
	       // roughly draw plate
	       translate([hToolPlateLeftBoltX-10, hWth+hAdapterThk, hToolPlateLeftBoltZ+10-tpHeight])
		    cube([tpWidth, 5, tpHeight]);
	       hull() {
		    translate([hToolPlateLeftBoltX-10, hWth+hAdapterThk, hToolPlateLeftBoltZ+10-tpHeight])
			 cube([tpWidth, 5, tpHeight/2]);
		    translate([hToolPlateLeftBoltX-12.5, hWth+hAdapterThk, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing])
			 rotate([-90, 0, 0]) cylinder(d=20, h=5, $fa=2, $fs=.1);
		    translate([hToolPlateRightBoltX+12.5, hWth+hAdapterThk, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing])
			 rotate([-90, 0, 0]) cylinder(d=20, h=5, $fa=2, $fs=.1);
	       }

	       // Balls
	       translate([(hToolPlateRightBoltX + hToolPlateLeftBoltX)/2, hWth+hAdapterThk+5+5, hToolPlateLeftBoltZ])
		    sphere(5, $fa=2, $fs=.1);
	       translate([hToolPlateLeftBoltX-12.5, hWth+hAdapterThk+5+5, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing+3])
		    sphere(5, $fa=2, $fs=.1);
	       translate([hToolPlateRightBoltX+12.5, hWth+hAdapterThk+5+5, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing+3])
		    sphere(5, $fa=2, $fs=.1);
	  }
     
	  // draw bolt holes
	  translate([hToolPlateLeftBoltX, hWth+hAdapterThk, hToolPlateLeftBoltZ])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);
	  translate([hToolPlateRightBoltX, hWth+hAdapterThk, hToolPlateRightBoltZ])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);

	  translate([hToolPlateLeftBoltX, hWth+hAdapterThk, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);
	  translate([hToolPlateRightBoltX, hWth+hAdapterThk, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);

     	  translate([hToolPlateLeftBoltX, hWth+hAdapterThk, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);
	  translate([hToolPlateRightBoltX, hWth+hAdapterThk, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);

     	  translate([hToolPlateLeftBoltX, hWth+hAdapterThk, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);
	  translate([hToolPlateRightBoltX, hWth+hAdapterThk, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=3, h=5, $fa=2, $fs=.1);
	  
	  // Slot
     	  translate([(hToolPlateRightBoltX + hToolPlateLeftBoltX)/2, hWth+hAdapterThk, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing+wSlotAbove3rdHole])
	       rotate([-90, 0, 0]) cylinder(d=8, h=5, $fa=2, $fs=.1);
     	  translate([(hToolPlateRightBoltX + hToolPlateLeftBoltX)/2-10, hWth+hAdapterThk, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing+wSlotAbove3rdHole-2])
	       cube([20,5,4]);
     }
}

if (needAdapter) {
     difference () {
	  translate([hXBolt1Off-11, hWth, hNozZ-3-3]) cube([hXBoltDiff+3+11, hAdapterThk, hHt+3]);

	  // cutout in center
     	  translate([(hToolPlateRightBoltX + hToolPlateLeftBoltX)/2, hWth, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing+wSlotAbove3rdHole])
	       rotate([-90, 0, 0]) cylinder(d=20, h=hAdapterThk, $fa=2, $fs=.1);

	  //mount bolt holes with insets for head
	  boltDepth = 3;
	  translate([hXBolt2Off, hWth+hAdapterThk, hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltSize, h=hAdapterThk, $fa=2, $fs=.1);
	  translate([hXBolt2Off, hWth+hAdapterThk+boltDepth, hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltHeadSize, h=hAdapterThk, $fa=2, $fs=.1);
	  translate([hXBolt2Off-hBoltHeadSize/2, hWth+boltDepth, hNozZ-10]) cube([hBoltHeadSize, hAdapterThk, 10]);
	  translate([hToolPlateRightBoltX+12.5, hWth+boltDepth, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing+3]) rotate([-90, 0, 0]) cylinder(d=8, h = hAdapterThk, $fa=2, $fs=.1);
	  
	  translate([hXBolt2Off, hWth+hAdapterThk, hYBoltDiff+hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltSize, h=hAdapterThk, $fa=2, $fs=.1);
	  translate([hXBolt2Off, hWth+hAdapterThk+boltDepth, hYBoltDiff+hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltHeadSize, h=hAdapterThk, $fa=2, $fs=.1);
	  translate([hXBolt2Off-hBoltHeadSize/2, hWth+boltDepth, hYBoltDiff+hNozZ]) cube([hBoltHeadSize, hAdapterThk, 10]);
	  
	  translate([hXBolt1Off, hWth+hAdapterThk, hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltSize, h=hAdapterThk, $fa=2, $fs=.1);
	  translate([hXBolt1Off, hWth+hAdapterThk+boltDepth, hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltHeadSize, h=hAdapterThk, $fa=2, $fs=.1);
	  
	  translate([hXBolt1Off, hWth+hAdapterThk, hYBoltDiff+hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltSize, h=hAdapterThk, $fa=2, $fs=.1);
	  translate([hXBolt1Off, hWth+hAdapterThk+boltDepth, hYBoltDiff+hNozZ]) rotate([90, 0, 0]) cylinder(d=hBoltHeadSize, h=hAdapterThk, $fa=2, $fs=.1);
	  
	  // toolplate bolt holes
	  boltSize = 3-.2;

	  translate([hToolPlateLeftBoltX, hWth, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=boltSize, h=hAdapterThk+1, $fa=2, $fs=.1);
	  translate([hToolPlateRightBoltX, hWth, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=boltSize, h=hAdapterThk+1, $fa=2, $fs=.1);

     	  translate([hToolPlateLeftBoltX, hWth, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=boltSize, h=hAdapterThk+1, $fa=2, $fs=.1);
	  translate([hToolPlateRightBoltX, hWth, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=boltSize, h=hAdapterThk+1, $fa=2, $fs=.1);

     	  translate([hToolPlateLeftBoltX, hWth, hToolPlateLeftBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=boltSize, h=hAdapterThk+1, $fa=2, $fs=.1);
	  translate([hToolPlateRightBoltX, hWth, hToolPlateRightBoltZ-wTopTo2ndHoleSpacing-w2ndTo3rdHoleSpacing-w3rdTo4thHoleSpacing])
	       rotate([-90, 0, 0]) cylinder(d=boltSize, h=hAdapterThk+1, $fa=2, $fs=.1);

     }
}

// draw rough shape of hemera for reference

if (needHemera) {
     translate([0, 0, hNozZ-3]) {
	  difference() {
	       cube([hLen, hWth, hHt]);
	       translate([hXBolt2Off, 3, 3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);
	       translate([hXBolt2Off, 3, hYBoltDiff+3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);
	       translate([hXBolt1Off, 3, 3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);
	       translate([hXBolt1Off, 3, hYBoltDiff+3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);

	       translate([hXBolt2Off, hWth, 3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);
	       translate([hXBolt2Off, hWth, hYBoltDiff+3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);
	       translate([hXBolt1Off, hWth, 3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);
	       translate([hXBolt1Off, hWth, hYBoltDiff+3]) rotate([90, 0, 0]) cylinder(d=3, h=3, $fa=2, $fs=.1);
	       translate([hNozX, hNozY, hHt-10])cylinder(d=3, h=15, $fa=2, $fs=.1);
	  }
	  
	  translate([hNozX -hBlkWth/2, hNozY-hBlkLen+hBlkNozLenOff, -hNozZ+3+hNozBellowBlk]) cube([hBlkWth, hBlkLen, hBlkHt]);
	  translate([hNozX, hNozY, -hNozZ+3]) cylinder(d=2, h=hNozBellowBlk, $fa=2, $fs=.1);
	  translate([hEFanThk, -1, -1]) cube([1,hWth+2, hHt+2]);
	  translate([hEFanThk+hECoolVaneThk, -1, -1]) cube([1,hWth+2, hHt+2]);
     }
}

if (needHemeraStl) {
     translate([hXBolt1Off-3, hWth/2, hNozZ-4])rotate([0, 0, -90])import("../E3D_Hemera_Final.stl");
}
//translate([hNozX, hNozY, hHt-10])cylinder(d=4, h=100, $fa=2, $fs=.1);
//	  translate([postRightX, -10, postZ])
//	       rotate([-90, 0, 0]) cylinder(d=postSlideDia, h=hWth+hAdapterThk+.1, $fa=2, $fs=.1);
