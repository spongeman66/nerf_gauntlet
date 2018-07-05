include <constants.scad>
cuff_angle = atan((motormount_w- w_thickness*2)/(cuff_outer_r * 2 - mount_offset/2));
pusher_throw = cyl_len - jam_slot_offset_from_top;
pusher_overthrow = pusher_throw  + jam_slot_support_len;
echo("pusher_throw:", pusher_throw);
echo("pusher_overthrow:", pusher_overthrow);
height_to_flywheels = cyl_len + motormount_w/2;
echo("height_to_flywheels:", height_to_flywheels);
connecting_rod_len = pusher_overthrow + post_d;
connecting_rod_w = 8;
connecting_rod_t = 5;
pusher_motor_l = 56;
pusher_motor_d = 36;
pusher_motor_shaft_d = 25.4/8;  // 1/8 inch -> mm
pusher_motor_shaft_l = 15;
pusher_motor_pinion_d = 10;
pusher_wheel_d = 70;

module motor_540(){
    translate([0, 0, -pusher_motor_l])
        union(){
            cylinder(pusher_motor_l, d=pusher_motor_d);
            translate([0, 0, pusher_motor_l])
                cylinder(pusher_motor_shaft_l, d=pusher_motor_shaft_d);
        }
}
module connecting_rod(){
    difference() {
        union () {
            translate([pusher_overthrow/2 + post_d/2, 0, -connecting_rod_t])
                cylinder(connecting_rod_t, d=post_d);
            hull() {
                translate([connecting_rod_len/2, 0, 0])
                    cylinder(connecting_rod_t, d=connecting_rod_w);
                translate([-connecting_rod_len/2, 0, 0])
                    cylinder(connecting_rod_t, d=connecting_rod_w);
            }
        }
        translate([-pusher_overthrow/2 - post_d/2, 0, 0])
            cylinder(connecting_rod_t, d=post_d);
    }
}

module pusher_wheel(){
    union() {
        difference() {
            union() {
                cylinder(2, d=pusher_wheel_d);
                cylinder(5, d=pusher_overthrow + post_d);
            }
            cylinder(connecting_rod_t, d=post_d);
        }
        translate([pusher_overthrow/2, 0, 5])
            cylinder(connecting_rod_t, d=post_d);
        translate([connecting_rod_len/2 + pusher_overthrow/2 -post_d/2 -w_thickness*2, 0, connecting_rod_t])
            connecting_rod();
    }
}

module bearing_plate() {
    translate([mount_offset - w_thickness/2, 0, 0]) {
        union () {
            translate([0, 0, (cuff_h + motormount_w)/2])
                cube([w_thickness, mount_w, cuff_h + motormount_w], center=true);
            translate([w_thickness/2 + pusher_motor_d/2 + w_thickness + pusher_motor_pinion_d/2, 0, pusher_overthrow * 2])
                rotate([0, 90, 0])
                pusher_wheel();
            translate([pusher_motor_d/2 + w_thickness, 0, pusher_overthrow * 2 + pusher_wheel_d/2 + w_thickness*2])
                rotate([180, 0, 0])
                motor_540();
        }
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
//motor_540();