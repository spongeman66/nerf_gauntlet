include <constants.scad>

module screw_hole(hole_len=(w_thickness*2)) {
    union(){
        // tapered part
        cylinder(w_thickness, d1=brushless_motor_screw_d + w_thickness, d2=brushless_motor_screw_d);
        cylinder(hole_len, d=brushless_motor_screw_d);
    }
}

module screw_holes(hole_len=(w_thickness*2)) {
    offset = brushless_motor_screw_mount_side/2;
    translate([offset, offset, 0]) screw_hole(hole_len);
    translate([-offset, offset, 0]) screw_hole(hole_len);
    translate([offset, -offset, 0]) screw_hole(hole_len);
    translate([-offset, -offset, 0]) screw_hole(hole_len);
}

module motor_mount(){
    translate([0,0, -mount_alignment])
    union () {
        // flat plate - screw holes
        difference () {
            translate([0, 0, m_thickness / 2])
                cube([motormount_w, motormount_w, m_thickness], center=true);
            screw_holes(m_thickness);
        }
        // cover mount
        translate([motormount_w/2, 0, -dart_d/2 + m_thickness])
            cube([m_thickness, motormount_w, dart_d], center=true);

        // slider mount
        translate([-slider_offset, 0, -slider_t/2])
            slide_mount(w_thickness * 6, motormount_w, slider_t, top=true);
            
        // flywheel -- remove before printing
        translate([0, 0, m_thickness])
            union() {
                difference() {
                    cylinder(flywheel_thickness + brushless_motor_h, r=(brushless_motor_d/2 + flywheel_thickness + dart_r)-w_thickness);
                    *translate([0, 0, (flywheel_thickness + brushless_motor_h)/2])
                        rotate_extrude(convexity = 10)
                        translate([brushless_motor_d/2 + flywheel_thickness + dart_r, 0, 0])
                        circle(d = dart_d);
                }
                cylinder(brushless_motor_h * 2, d=brushless_motor_screw_d);
            }
    }
}

module motor_mounts() {
    union () {
        translate([motormount_w/2, 0, 0]) motor_mount();
        translate([-motormount_w/2, 0, 0]) mirror([1, 0, 0]) motor_mount();
    }
}
module printable_motor_mounts() {
    rotate([0, 180, 0])
        translate([0, 0, mount_alignment - m_thickness])
            motor_mounts();
}
printable_motor_mounts();