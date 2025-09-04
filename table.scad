
include <BOSL2/std.scad>

// Playable surface area
w = 45;		// 4' wide - 2 * 1.5" walls
l = 93;		// 8' long - 2 * 1.5" walls
t = 0.25; // 1/4" sheet

wh = 2.5; // 2.5" wall height
ww = 1.5; // 1.5" wall width


tx = 5.4 * ($t^2) - 5.59 * $t + 1.43;
closed = min(max(tx,0), 1);

module cubh(d, center) {
	difference() {
		cube([d[0], d[1], d[2]], center=true);
		// cube([d[0]-0.2, d[1]-0.2, 2], center=true);
	}
}

module fullsheet() {
	cubh([120,60,0.25], center=true);
}

// down(0.25) fullsheet();

// #up(1) color("blue") cubh([96,48,0.25], center=true);

module section(center=false) {

	if (!center) {
		color("#7272a7") cubh([l/3,w,0.25], center=true);
		right(l/6) end_wall();
	}
	else {
		color("#7979e5ff") cubh([l/3,w,0.25], center=true);
	}

	translate([0,w/2,0]) side_wall();
	mirror([0,1,0]) translate([0,w/2,0]) side_wall();
}

tl = 4; // tab length
cl = sqrt(ww^2 + ww^2);

module end_wall() {
			rotate([0,closed*-90,0]) {
				right(wh/2) color("lightblue") cubh([wh,w,t], center=true);

				// inner tabs
				fwd(w/2) right(wh/2) rotate([-90*closed, 0, 0]) fwd(tl/2) tab();
				mirror([0,1,0]) fwd(w/2) right(wh/2) rotate([-90*closed, 0, 0]) fwd(tl/2) tab();

				right(wh) rotate([0,closed*90,0]) {

					// wall top
					color("#ffec8e")
						right(ww/2) {
							cubh([ww,w,t], center=true);
							linear_extrude(0.25, center=true) {
								fwd(w/2) polygon([[-ww/2,0], [-ww/2,-ww], [ww/2,0]]);
								mirror([0,1,0]) fwd(w/2) polygon([[-ww/2,0], [-ww/2,-ww], [ww/2,0]]);
							}
						}

					right(ww) rotate([0,closed*90,0]) right(wh/2) {
							color("lightblue") cubh([wh,w,t], center=true);
							corner_tab();
							mirror([0,1,0]) corner_tab();
						}
			}
		}
}

module corner_tab() {
	fwd(w/2) rotate([closed*45,0,0]) fwd(cl/2) {
		color("#e0e055") cubh([wh,cl,0.25], center=true);
		fwd(cl/2) rotate([closed*45,0,0]) fwd(tl/2) color("#40a055") cubh([wh-2*t,tl,0.25], center=true);
	}
}

module side_wall() {
				rotate([closed*90,0,0]) {
				back(wh/2) color("lightblue") cubh([l/3,wh,t], center=true);
				back(wh) rotate([closed*-90,0,0]) {
					color("#f6d484") back(ww/2) cubh([l/3,ww,t], center=true);
					color("lightblue") back(ww) rotate([closed*-90,0,0]) back(wh/2) cubh([l/3,wh,t], center=true);
				}
	}
}

module tab() {
	color("blue") {
		union() {
			cubh([wh-2*t,tl,t], center=true);
		}
	}
}

projection(cut=false) {
left(7) fwd(1) {
translate([-l/3-(1*closed),0,0]) rotate([0,0,180]) section();
section(true);
translate([l/3+(1*closed),0,0]) section();
}
}

module corner() {
up(wh/2) union() {
	// cuboid([5,5,2], rounding=1, edges="Z", $fn=40);
	fwd(1.5) cubh([4,1,0.25], center=true);
	left(1.5) cubh([1,4,0.25], center=true);
}
}
// corner();
// for(z = [0:1:8]) {
// 	up(z*0.25) corner();
// }

// for (x = [-w/2:])