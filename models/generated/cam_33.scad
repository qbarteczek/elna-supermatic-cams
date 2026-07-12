/* 
  Elna Supermatic cam 33
  Generated from cam_33_profile.json

  License: GPL-3.0-or-later.
  Based on dimensions and 18-position cam profile workflow compatible with
  ln-komandur/elna-cam-discs.
*/

use <../original/Cam-as-18-Sided-Polygon.scad>

disc_thickness = 7;
thickest_cyl_rad = 17;
lobe_thickness = 4.5;
inner_hole_rad = 8.25;
hole_bigger_rad = 9.5;
bigger_hole_ht = 1.5;
hole_cone_ht = 1.5;
cut_errors = 0.1;
skirting = 0;
skirting_width = 1.5;

gap_to_transporthole = 1;
transporthole_width = 3;
transporthole_depth = 5.5;
transporthole_length = 4;

l = 0;
cl = 0.75;
c = 1.5;
cr = 2.25;
r = 3;

module cam_33() {
    difference() {
        union() {
            cylinder(h = disc_thickness, r = thickest_cyl_rad);
            translate([0, 0, skirting])
                cylinder(h = disc_thickness - skirting * 2, r = thickest_cyl_rad + skirting_width);

            translate([0, 0, skirting])
                linear_extrude(height = lobe_thickness)
                    plotpoly(l, r, l, r, l, r, l, r, l, c, l, c, l, c, l, c, l, c);

            translate([-5, -15, disc_thickness - 0.45])
                linear_extrude(height = 0.5)
                    text("33", size = 5, halign = "center", valign = "center");
        }

        translate([0, 0, disc_thickness / 2])
            cylinder(h = disc_thickness + 1, r = inner_hole_rad, center = true);

        translate([0, 0, -cut_errors])
            cylinder(h = bigger_hole_ht + cut_errors, r = hole_bigger_rad);

        translate([0, 0, bigger_hole_ht - cut_errors])
            cylinder(h = hole_cone_ht, r1 = hole_bigger_rad, r2 = inner_hole_rad);

        translate([0, hole_bigger_rad + gap_to_transporthole + transporthole_length / 2,
                   transporthole_depth / 2 - cut_errors])
            cube(size = [transporthole_width, transporthole_length, transporthole_depth], center = true);
    }
}

cam_33();
