include <constants.scad>
cuff_angle = atan((motormount_w- w_thickness*2)/(cuff_outer_r * 2 - mount_offset/2));

module bearing_mount(mount_height) {
    mount_x = bearing_d/2 + w_thickness;
    mount_y = w_thickness + max(bearing_inner_d, bearing_d -  w_thickness*2);
    mount_z = min(mount_height - w_thickness/2, bearing_d * 2);
    
    translate([0, 0, mount_height]) {
        difference() {
            union() {
                translate([bearing_d/2 + w_thickness, 0, 0])
                    union() {
                        //bearing shim
                        translate([0, 0, -w_thickness/2])
                            cylinder(w_thickness/2, d=bearing_inner_d+w_thickness/2);
                        //rounded part of mount
                        translate([0, 0, -mount_z -w_thickness/2])
                            cylinder(mount_z, d=mount_y);
                    }
                //rectangular part of mount
                translate([mount_x/2, 0, -mount_z/2 -w_thickness/2])
                    cube([mount_x, mount_y, mount_z], center=true);
            }
            union () {
                //remove angled part at an angle so we can print it
                translate([mount_x *2, 0, -(race1 + w_thickness*2)]) rotate([0, 90-print_no_support_angle, 0])
                    cube([mount_x *2, mount_y, mount_z * 2], center=true);
                // and final screw hole
                translate([bearing_d/2 + w_thickness, 0, -mount_z*2])
                    cylinder(mount_z*2, d=bearing_inner_d);
            }
        }
    }
}

module slider_base(x, y, z) {
    translate([x, y, z])
        rotate([-90, 0, 0]) rotate([0, 90, 0])
        difference() {
            slide_mount(w_thickness * 6, motormount_w, slider_t, top=false);
            translate([0, motormount_w/2, 0])
            rotate([print_no_support_angle, 0, 0])
                cube([slider_t, w_thickness * 6, motormount_w], center=true);
        }
}

module bearing_plate() {
    translate([mount_offset - w_thickness/2, 0, 0]) {
        union () {
            translate([0, 0, (cuff_h + motormount_w)/2])
                cube([w_thickness, mount_w, cuff_h + motormount_w], center=true);
            bearing_mount(race1 + w_thickness + clearance);
            bearing_mount(race2 + w_thickness + clearance);
            slider_base(slider_t/2 + w_thickness/2, motormount_w/2 -slider_offset, cuff_h + motormount_w/2);
            slider_base(slider_t/2 + w_thickness/2, -(motormount_w/2 -slider_offset), cuff_h + motormount_w/2);
            }
    }
}

module screw_hole(hole_len=(w_thickness*2)) {
    union(){
        // tapered part
        cylinder(w_thickness, d1=brushless_motor_screw_d + w_thickness, d2=brushless_motor_screw_d);
        cylinder(hole_len, d=brushless_motor_screw_d);
    }
}

module printable_cylinder_mount() {
    difference() {
        union () {
            cuff(cuff_angle);
            bearing_plate();
        }
        *translate([0, 0, cuff_h + motormount_w + sin(cuff_angle)*cyl_draw_radius/2])
            rotate([0, -cuff_angle, 0])
                // just a big block to remove
                cube([cyl_draw_radius * 4, cyl_draw_radius * 2, cyl_draw_radius], center=true);
    }
}

printable_cylinder_mount();
