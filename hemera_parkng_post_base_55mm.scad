$fn=50;
difference() {
     translate([0,0,0])rotate([0, 0, 0]){
	  union() {
	       minkowski(){
		    translate([1,1,0]) cube([59,16,16]);
		    translate([1, 1, 0])cylinder(r=2, h=1);
	       }
	       translate([-118.5, -130, 15])import("parking_post_base_55mm.STL", convexity=5);
	  }
     }
     translate([8, 10, 0])cylinder(d=5.1, h=25, $fa=2, $fs=.1);
     translate([55, 10, 0])cylinder(d=5.1, h=25, $fa=2, $fs=.1);
     translate([8, 10, 14])cylinder(d=10.1, h=30, $fa=2, $fs=.1);
     translate([55, 10, 14 ])cylinder(d=10.1, h=30, $fa=2, $fs=.1);
}
