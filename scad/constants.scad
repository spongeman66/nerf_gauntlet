$fn = 128;
//dart_d = 19;  // elite dart diameter
//d_len = 95;   // elite dart length
dart_d = 13;  // elite dart diameter
d_len = 72;   // elite dart length
w_thickness = 1.6;  //multiples of 3d printer head diameter -> 4 * 0.4
chamber_count = 28;
//chamber_count = 10;
jam_slot_width = 5.6;
jam_slot_support_len = 8;
race1 = 10;  //bottom edge of bearing race position.
bearing_w = 4;
bearing_d = 10;
bearing_inner_d = 5;
ratchet_angle = -20;
clearance = 0.2;  // wherever plastic meets plastic

brushless_motor_d = 22;
brushless_motor_h = 12;
flywheel_thickness = w_thickness * 2;
brushless_motor_screw_d = 5;
brushless_motor_screw_mount_r = 19/2;

// calculated constants
dart_r = dart_d/2;

brushless_motor_screw_mount_side = brushless_motor_screw_mount_r * sqrt(2);
motormount_w = (dart_r + flywheel_thickness) * 2 + brushless_motor_d;

cyl_len = d_len + w_thickness * 2;
race2 = cyl_len - race1 - bearing_w; // bottom edge of upper bearing
toroid_r = dart_d + w_thickness;
chamber_r = dart_r + w_thickness;
chamber_d = chamber_r * 2;
cyl_degrees = 360/chamber_count;
// chambers only need 1 w_thickness between each other
cyl_draw_radius = (dart_r + w_thickness/2) / sin(cyl_degrees/2);
cyl_inner_thickness = w_thickness;

inner_r = cyl_draw_radius - dart_r - w_thickness;
final_inner = inner_r - cyl_inner_thickness;
race_r = final_inner + w_thickness;

// ratchet constants
post_d = w_thickness * 2;
slot_l = chamber_d + post_d; // a little extra movement
ratchet_l = chamber_d*2 + slot_l + post_d;
ratchet_w = post_d + w_thickness * 2;
ratchet_t = w_thickness * 1.5;

// constants for the motor mount and cylinder mount
cuff_outer_r = final_inner - w_thickness;
cuff_inner_r = cuff_outer_r - w_thickness;
cuff_h = cyl_len + w_thickness *2;
flange_r = cuff_outer_r + toroid_r;
bearing_mount_r = race_r - bearing_d/2;
mount_offset = race_r - bearing_d - w_thickness * 2;
mount_w = sqrt(cuff_outer_r * cuff_outer_r - mount_offset * mount_offset) * 2;
m_thickness = w_thickness * 2;
mount_alignment = m_thickness + (flywheel_thickness + brushless_motor_h)/2;
slider_t = cyl_draw_radius - mount_alignment - mount_offset;

// returns a list of angles for the points of a regular polygon
function regular_polygon_angles(order) = [for (i=[0:order-1]) i*(360/order)];

// returns a list of coordinates and angle for the endpoints of a regular polygon
function regular_polygon_translation(order, r=1) = [
    for (th=regular_polygon_angles(order)) [[r*cos(th), r*sin(th), 0], th]];

module pipe(h, inner, outer) {
    difference() {
        cylinder(h, r=outer);
        cylinder(h, r=inner);
    }
}
module toroid(circle_r, toroid_r, convexity=10) {
    rotate_extrude(convexity)
    translate([toroid_r, 0, 0]) circle(r = circle_r);

}
module slide_slot(w, h, l, c=-clearance) {
    t_w = w * 2/3;
    t_l = l/2 + c;
    // clearance can be negative when building the part that goes inside
    difference() {
        union() {
            cube([w-t_w, h, l], center=true);
            translate([0, 0, l-t_l])
                resize([t_w + c , 0, 0]) rotate([0, 45, 0])
                cube([t_w, h, t_w], center=true);
        }
        translate([0, 0, l])
            cube([l, h, l], center=true);
        
    }
}




