include <constants.scad>

module flange(){
    pipe(w_thickness, cuff_inner_r, flange_r);
}
module cuff () {
    difference () {
        difference () {
            union () {
                pipe(cuff_h + motormount_w, cuff_inner_r, cuff_outer_r);
                flange();
            }
            translate([mount_offset + (toroid_r + bearing_d + w_thickness *2)/2, 0, (cuff_h + motormount_w)/2])
                cube([toroid_r + bearing_d + w_thickness *2, mount_w, cuff_h + motormount_w], center=true);
        }
        angle = atan(motormount_w/(cuff_outer_r * 2 - mount_offset/2));
        rotate([0, -angle, 0])
            translate([0, 0, cuff_h + motormount_w+ w_thickness])
                cube([cyl_draw_radius * 4, cyl_draw_radius * 2, cyl_draw_radius], center=true);
    }
}

module bearing_mount(mount_height) {
    mount_x = bearing_d/2 + w_thickness;
    mount_y = bearing_inner_d + w_thickness;
    mount_z = bearing_inner_d * 2 + w_thickness;
    
    translate([0, 0, mount_height]) {
        difference() {
            union() {
                translate([bearing_d/2 + w_thickness, 0, 0])
                    union() {
                        //bearing mount
                        difference() {
                            cylinder(bearing_w + w_thickness, d=bearing_inner_d);
                            cylinder(bearing_w + w_thickness, d=bearing_inner_d - w_thickness * 2);
                        }
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
            //remove angled part at 50 degrees so we can print it
            translate([mount_x, 0, -mount_z]) rotate([0, 90-50, 0])
                cube([mount_x, mount_y, mount_z * 2], center=true);
        }
    }
}
module bearing_plate() {
    translate([mount_offset - w_thickness/2, 0, 0]) {
        union () {
            translate([0, 0, (cuff_h + motormount_w)/2])
                cube([w_thickness, mount_w, cuff_h + motormount_w], center=true);
            bearing_mount(race1 + w_thickness * 2);
            bearing_mount(race2 + w_thickness * 2);
            
            translate([slider_t/2 + w_thickness/2, 0, cuff_h + motormount_w/2])
                rotate([-90, 0, 0])
                rotate([0, 90, 0])
                difference() {
                    slide_mount(slider_t, w_thickness * 6, motormount_w, top=false);
                    translate([0, motormount_w/2, 0])
                    rotate([50, 0, 0])
                        cube([slider_t, w_thickness * 6, motormount_w], center=true);
                }
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
        difference () {
            translate([0, 0, m_thickness / 2])
                cube([motormount_w, motormount_w, m_thickness], center=true);
            screw_holes(m_thickness);
        }
        translate([motormount_w/2, 0, -dart_d/2 + m_thickness])
            cube([m_thickness, motormount_w, dart_d], center=true);

        // flywheel -- remove before printing
        *translate([0, 0, m_thickness])
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
module slide_mount(slider_t, slider_w, slider_l, top=true) {
    if (top==true) {
        difference() {
            cube([slider_w, slider_l, slider_t], center=true);
            slide_slot(slider_w, slider_l, slider_t, clearance);
        }
    } else {
        slide_slot(slider_w, slider_l, slider_t, -clearance);
    }
}

module motor_mounts() {
    union () {
        translate([motormount_w/2, 0, 0]) motor_mount();
        translate([-motormount_w/2, 0, 0]) mirror([1, 0, 0]) motor_mount();
        translate([0, 0, -mount_alignment -slider_t/2])
            slide_mount(slider_t, w_thickness * 6, motormount_w, top=true);
    }
}
render_mount = false;
//include <motor_mount.scad>  //uncomment if render_mount == true
union () {
    if (render_mount==true) {

        translate([cyl_draw_radius, 0, motormount_w/2 + cuff_h])
        rotate([0, 90, 0]) rotate([0, 0, 90])
            motor_mounts();
    }
    cuff();
    bearing_plate();
}
