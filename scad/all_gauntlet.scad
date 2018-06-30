include <constants.scad>
use <cylinder_mount.scad>
use <motor_mount.scad>
use <cylinder.scad>
union () {
    printable_cylinder_mount();
    translate([cyl_draw_radius, 0, motormount_w/2 + cuff_h])
        rotate([0, 90, 0]) rotate([0, 0, 90])
            motor_mounts();
    translate([0, 0, w_thickness + clearance])
        final_cylinder();
}
