include <constants.scad>

module slot () union () {
    // slot
    translate([0, 0, ratchet_t/2])
        cube([post_d, slot_l, ratchet_t], center=true);
    // rounded end 1
    translate([0, slot_l/2, 0])
        cylinder(d=post_d, h=ratchet_t);
    // rounded end 2
    translate([0, -slot_l/2, 0])
        cylinder(d=post_d, h=ratchet_t);
}

module bar () {
    difference () {
        union () {
            // main ratchet
            translate([0, 0, ratchet_t/2])
                cube([ratchet_w, ratchet_l, ratchet_t], center=true);
            // rounded end
            translate([0, -ratchet_l/2, 0])
                cylinder(d=ratchet_w, h=ratchet_t);
        }
        // spring hole
        translate([0, -ratchet_l/2, 0])
            cylinder(d=w_thickness, h=ratchet_t);
    }
}

module ratchet () {
    difference () {
        bar();
        slot();
    }
}
ratchet();
