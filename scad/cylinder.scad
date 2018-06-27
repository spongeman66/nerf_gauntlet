include <constants.scad>

module chamber(angle=0) {
    cu_w = chamber_d - w_thickness;  //reduce overlap
    jswhalf = jam_slot_width/2.0;
    jswallw = jam_slot_width + 2.0 * w_thickness;
    jswallh = jswallw / 2;

    rotate(angle + 90) difference() {
		union() {
			difference() {
				difference () {
					union () {
						cylinder(h=cyl_len, r=chamber_r);
						// inner flat
						translate([0, chamber_r/2 + w_thickness, cyl_len/2])
							cube(size=[cu_w, chamber_r, cyl_len], center=true);
						// outer jam slot
						translate([0, -dart_r -jswhalf/2, cyl_len/2])
							cube([jswallw, jswhalf, cyl_len], center=true);
					}
                    // remove the channel for fixing any dart jams
					translate([-jswhalf, -dart_r -jswallh, -(toroid_r + jam_slot_support_len)])
						cube ([jam_slot_width, jam_slot_width, cyl_len]);
				}
				// remove the part where the dart will go
				cylinder(h=cyl_len, r=dart_r);
			}
			// add bottom dart stopper
			difference(){
				cylinder(h=w_thickness *2, r=dart_r);
				// remove slot for pusher
				translate([0, -w_thickness, w_thickness])
					cube([jam_slot_width, dart_d, w_thickness * 2], center=true);
				}
		}
		// remove angled section for the revolver ratchet 
		// NOTE: change sign of ratchet_angle for cylinder to rotate in other direction
		ratchet_h = abs(chamber_d * tan(ratchet_angle));
		ratchet_w = abs(chamber_d / cos(ratchet_angle));// *2; // needs to be long
        translate([-1 *sign(ratchet_angle) * w_thickness/2, chamber_r, 0])
	    	rotate(a=[0, ratchet_angle, 0])
				cube(size=[ratchet_w, w_thickness * 2, ratchet_h], center=true);
	}
}

module chambers() {
    coords=regular_polygon_translation(chamber_count, r=cyl_draw_radius);
    for(t=coords) translate(t[0]) chamber(t[1]);
}

module full_cylinder() {
    difference() {
		difference() {
			union() {
				chambers();
				// smooth the inside of the cylinder
				translate([0, 0, w_thickness * 2])  // above the ratchet
					pipe(cyl_len - w_thickness * 2, final_inner, inner_r);
			}
			// bearing race1
			translate([0, 0, race1])
				pipe(bearing_w, final_inner, final_inner + w_thickness);
		}
		// bearing race2
		translate([0, 0, race2])
			pipe(bearing_w, final_inner, final_inner + w_thickness);
	}
}

module final_cylinder() {
    difference() {
        full_cylinder();
		// remove the toroid at the top of the cylinder
        translate([0, 0, cyl_len])
			rotate_extrude(convexity = 10, $fn=chamber_count)
			translate([cyl_draw_radius + chamber_r, 0, 0])
			circle(r = toroid_r, $fn=toroid_r * 5);
    }
}
//chamber(-90);
final_cylinder();