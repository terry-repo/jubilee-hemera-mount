$fn=50;

difference() {
     union() {
	  // main block
	  minkowski(){
	       translate([1, 1, 0]) cube([63,18.5,13]);
	       translate([1, 1, 0])cylinder(r=2, h=1);
	  }
	  // two "castle" blocks
	  translate([55, -8, 0])minkowski(){
	       translate([1, 1, 0]) cube([8,10,13]);
	       translate([1, 1, 0])cylinder(r=2, h=1);
	  }
	  translate([0, -8, 0])minkowski(){
	       translate([1, 1, 0]) cube([8,10,13]);
	       translate([1, 1, 0])cylinder(r=2, h=1);
	  }
     }

     // pin hole with gap 
     translate([61, 5, 0])cylinder(d=5.1, h=15, $fa=2, $fs=.1);
     translate([60.5, -9, 0])cube([1, 12, 20]);
     // angled slot for T-nut access
     translate([16, -1, 13])rotate([-94, 0, 15])cylinder(d=8, h=30, $fa=2, $fs=.1);
     // hole in "castle"
     translate([52, -3.5, 6.5])rotate([0, 90, 0]) cylinder(d=3.1, h=15, $fa=2, $fs=.1);
     translate([55, -3.5, 6.5])rotate([0, 90, 0]) cylinder(d=5.2, h=4, $fa=2, $fs=.1);
     // hole for slotted screw nut
     translate([46.7, 10.7, 10]) cylinder(d=5.2, h=4, $fa=2, $fs=.1);
     
     // pin hole with gap 
     translate([6, 5, 0])cylinder(d=5.1, h=15, $fa=2, $fs=.1);
     translate([5.5, -9, 0])cube([1, 12, 20]);
     // angled slot for T-nut access
     translate([51, -1, 13])rotate([-94, 0, -15])cylinder(d=8, h=30, $fa=2, $fs=.1);
     // hole in "castle"
     translate([0, -3.5, 6.5])rotate([0, 90, 0]) cylinder(d=3.1, h=15, $fa=2, $fs=.1);
     translate([8, -3.5, 6.5])rotate([0, 90, 0]) cylinder(d=5.2, h=4, $fa=2, $fs=.1);
     // hole for slotted screw nut
     translate([20.2, 10.7, 10]) cylinder(d=5.2, h=4, $fa=2, $fs=.1);

     // polygon cutout to slide over post
     translate([46.8, 3.7, 3.5]) rotate([-90, 180, 0]) linear_extrude(height=19.6) polygon(points=[[0,0], [26.3,0], [18.3,10.5], [7.5,10.5], [0,0]]);

     // hole for lift assist screw
     translate([33.5, 0, 8])rotate([-90, 0, 0])cylinder(d=3, h=5, $fa=2, $fs=.1);
     translate([33.5, 1, 8])rotate([-90, 0, 0])cylinder(r1=1.5, r2=4, h=3, $fa=2, $fs=.1);
}



