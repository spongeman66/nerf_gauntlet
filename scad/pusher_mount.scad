include <constants.scad>
cuff_angle = atan((motormount_w- w_thickness*2)/(cuff_outer_r * 2 - mount_offset/2));
pusher_throw = cyl_len - jam_slot_offset_from_top;
pusher_overthrow = pusher_throw  + jam_slot_support_len;
echo("pusher_throw:", pusher_throw);
echo("pusher_overthrow:", pusher_overthrow);
height_to_flywheels = cyl_len + motormount_w/2;
echo("height_to_flywheels:", height_to_flywheels);

connecting_rod_w = 8;
connecting_rod_t = 5;

pusher_wheel_d = pusher_overthrow + connecting_rod_w;
//pusher_wheel_d = 76;
echo("pusher_wheel_d:", pusher_wheel_d);

//connecting_rod_len = pusher_wheel_d + connecting_rod_w;
//connecting_rod_len = pusher_wheel_d + connecting_rod_w;
connecting_rod_len = pusher_wheel_d + connecting_rod_w/2;

//connecting_rod_len = pusher_overthrow + post_d;
//pusher_motor_l = 56;  // 540 motor size
//pusher_motor_d = 36;  // 540 motor size
pusher_motor_l = 49;  // 380 motor size
pusher_motor_d = 28;  // 380 motor size
pusher_motor_shaft_d = 25.4/8;  // 1/8 inch -> mm
pusher_motor_shaft_l = 9;
pusher_motor_pinion_d = 10;




module motor_540(){
    translate([0, 0, -pusher_motor_l])
        union(){
            cylinder(pusher_motor_l, d=pusher_motor_d);
            translate([0, 0, pusher_motor_l])
                cylinder(pusher_motor_shaft_l, d=pusher_motor_shaft_d);
            translate([0, 0, pusher_motor_l + pusher_motor_shaft_l - 4])
                cylinder(8, d1=pusher_motor_pinion_d + 2, d2=pusher_motor_pinion_d-2);
        }
}

module screw_slot(){
    hull() {
        translate([0, 5, 0])
            cylinder(w_thickness*2, r=1.5);
        translate([0, -5, 0])
            cylinder(w_thickness*2, r=1.5);

    }
}

module adjustable_540_mount() {
    translate([0, w_thickness*2, 0])
        union() {
        difference() {
            union(){
                translate([0, pusher_motor_l/2, pusher_motor_d/4])
                    cube([pusher_motor_d + w_thickness*2, pusher_motor_l, pusher_motor_d/2], center=true);
//                translate([0, pusher_motor_l/2, w_thickness])
//                    cube([pusher_motor_d + w_thickness*2, pusher_motor_l, w_thickness*2], center=true);
                translate([0, -w_thickness, pusher_motor_d/2 + w_thickness])
                    cube([pusher_motor_d + w_thickness*2, w_thickness*2, pusher_motor_d + w_thickness*2], center=true);
            }
            union(){
                translate([0, 0, pusher_motor_d/2 + w_thickness*2])
                    rotate([90, 0, 0])
                    hull() {
                        translate([0, 5, 0])
                            cylinder(w_thickness*2, r=5);
                        translate([0, -5, 0])
                            cylinder(w_thickness*2, r=5);
                    }
                translate([pusher_motor_d/4, 0, pusher_motor_d/2 + w_thickness*2])
                    rotate([90, 0, 0])
                    screw_slot();
                translate([-pusher_motor_d/4, 0, pusher_motor_d/2 + w_thickness*2])
                    rotate([90, 0, 0])
                    screw_slot();
                translate([0, 0, pusher_motor_d/2 + w_thickness/2])
                    rotate([-90, 0, 0])
                    cylinder(pusher_motor_l, d=pusher_motor_d);
                }
        }
//        translate([0, pusher_motor_pinion_d/2, pusher_motor_d/2 + w_thickness*2])
        translate([0, 0, pusher_motor_d/2 + w_thickness*2 + pusher_motor_pinion_d/2])
            rotate([90, 0, 0])
            motor_540();
    }
}

module connecting_rod(){
    translate([connecting_rod_len/2, 0, 0])
    difference() {
        union () {
            translate([connecting_rod_len/2, 0, -connecting_rod_t])
                cylinder(connecting_rod_t, d=post_d);
            hull() {
                translate([connecting_rod_len/2, 0, 0])
                    cylinder(connecting_rod_t, d=connecting_rod_w);
                translate([-connecting_rod_len/2, 0, 0])
                    cylinder(connecting_rod_t, d=connecting_rod_w);
            }
        }
        translate([-connecting_rod_len/2, 0, 0])
            cylinder(connecting_rod_t, d=post_d);
    }
}

pusher_extended = true;
module pusher_wheel(){
    union() {
        difference() {
            union() {
                cylinder(3, d1=pusher_wheel_d - connecting_rod_w*2, d2=pusher_wheel_d);
                translate([0, 0, 3])
                    cylinder(2, d=pusher_wheel_d);
//                    cylinder(3, d1=pusher_wheel_d, d2=pusher_overthrow + connecting_rod_w);
            }
            union () {
                cylinder(connecting_rod_t, d=bearing_inner_d);
                cylinder(bearing_w, d=bearing_d);
            }
        }
        if (pusher_extended) {
            translate([pusher_overthrow/2, 0, 5])
                cylinder(connecting_rod_t, d=post_d);
            translate([pusher_overthrow/2, 0, connecting_rod_t])
                #connecting_rod();
        } else {
            translate([-pusher_overthrow/2, 0, 5])
                cylinder(connecting_rod_t, d=post_d);
            #translate([-pusher_overthrow/2, 0, connecting_rod_t])
                connecting_rod();
        }
    }
}

pusher_motor_h = pusher_overthrow * 2 + pusher_wheel_d/2 + w_thickness*2;
pusher_wheel_offset = w_thickness*2 + pusher_motor_d/2 + pusher_motor_pinion_d/2 + 5/2;

module pusher_plate() {
    translate([mount_offset - w_thickness/2, 0, 0]) {
        union () {
            translate([0, 0, (pusher_motor_h + pusher_motor_l)/2 + w_thickness*2])
                cube([w_thickness, mount_w, pusher_motor_h + pusher_motor_l + w_thickness*4], center=true);
            translate([0, 0, pusher_overthrow * 2])
                rotate([0, 90, 0])
                union() {
                    cylinder(pusher_wheel_offset + 5, d=bearing_inner_d);
                    cylinder(pusher_wheel_offset, d=bearing_d);
                }
            translate([pusher_wheel_offset , 0, pusher_overthrow * 2])
                rotate([0, 90, 0])
                pusher_wheel();
//            translate([w_thickness*2 + pusher_motor_d/2 - pusher_motor_pinion_d/2 - 5/2, 0, pusher_overthrow * 2])
//                rotate([0, 90, 0])
//                pusher_wheel();
            translate([w_thickness/2, 0, pusher_motor_h+ w_thickness*2])
                rotate([90, 0, 90])
                adjustable_540_mount();
        }
    }
}

module printable_pusher_mount() {
    difference() {
        union () {
            cuff(cuff_angle);
            pusher_plate();
        }
        *translate([0, 0, cuff_h + motormount_w + sin(cuff_angle)*cyl_draw_radius/2])
            rotate([0, -cuff_angle, 0])
                // just a big block to remove
                cube([cyl_draw_radius * 4, cyl_draw_radius * 2, cyl_draw_radius], center=true);
    }
}

printable_pusher_mount();
//motor_540();
//adjustable_540_mount();
