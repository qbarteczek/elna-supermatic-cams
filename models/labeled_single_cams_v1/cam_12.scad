/*
  Elna Supermatic single cam 12
  Name: Spindle
  Status: candidate
  Visible raised number and stitch preview.

  IMPORTANT:
  Labels are raised geometry, not engraved text. They should be visible in render and print.
  Cam profile is still a candidate and must be verified against real photos/STL.

  License: GPL-3.0-or-later.
*/

$fn = 96;

disc_thickness = 7;
body_radius = 17;
outer_reference_radius = 18.5;
lobe_thickness = 4.5;
label_height = 0.80;

inner_hole_rad = 8.25;
hole_bigger_rad = 9.5;
bigger_hole_ht = 1.5;
hole_cone_ht = 1.5;
cut_errors = 0.1;

gap_to_transporthole = 1;
transporthole_width = 3;
transporthole_depth = 5.5;
transporthole_length = 4;

module lobe_profile() {
    polygon(points=[
        [-1.7731, 18.4148],
        [1.7731, 18.4148],
        [4.8824, 18.8789],
        [8.3950, 17.6004],
        [11.6113, 16.8946],
        [14.6216, 14.3686],
        [17.5035, 12.4851],
        [19.5642, 8.9159],
        [19.7544, 5.4784],
        [20.4368, 1.6084],
        [19.4399, -1.5300],
        [18.7908, -5.2111],
        [16.8343, -7.6718],
        [15.0611, -10.7430],
        [13.9084, -13.6677],
        [11.0449, -16.0705],
        [8.8255, -18.5030],
        [5.1328, -19.8470],
        [2.0607, -21.4010],
        [-2.0607, -21.4010],
        [-5.1328, -19.8470],
        [-8.8255, -18.5030],
        [-11.0449, -16.0705],
        [-13.9084, -13.6677],
        [-15.0611, -10.7430],
        [-16.8343, -7.6718],
        [-18.7908, -5.2111],
        [-19.4399, -1.5300],
        [-20.4368, 1.6084],
        [-19.7544, 5.4784],
        [-19.5642, 8.9159],
        [-17.5035, 12.4851],
        [-14.6216, 14.3686],
        [-11.6113, 16.8946],
        [-8.3950, 17.6004],
        [-4.8824, 18.8789]
    ]);
}

module digit_segments(d) {
    // 7-segment digit, raised from cubes. Local digit approx 2.4 x 4.0 mm.
    seg_w = 2.2;
    seg_t = 0.42;
    seg_v = 1.72;

    module hseg(y) {
        translate([-seg_w/2, y, disc_thickness])
            cube([seg_w, seg_t, label_height]);
    }
    module vseg(x, y) {
        translate([x, y, disc_thickness])
            cube([seg_t, seg_v, label_height]);
    }

    // segment map: a top, b upper-right, c lower-right, d bottom, e lower-left, f upper-left, g middle
    if (d == 0) { hseg(1.8); vseg(0.85,0.15); vseg(0.85,-1.65); hseg(-1.8); vseg(-1.25,-1.65); vseg(-1.25,0.15); }
    if (d == 1) { vseg(0.85,0.15); vseg(0.85,-1.65); }
    if (d == 2) { hseg(1.8); vseg(0.85,0.15); hseg(0); vseg(-1.25,-1.65); hseg(-1.8); }
    if (d == 3) { hseg(1.8); vseg(0.85,0.15); hseg(0); vseg(0.85,-1.65); hseg(-1.8); }
    if (d == 4) { vseg(-1.25,0.15); hseg(0); vseg(0.85,0.15); vseg(0.85,-1.65); }
    if (d == 5) { hseg(1.8); vseg(-1.25,0.15); hseg(0); vseg(0.85,-1.65); hseg(-1.8); }
    if (d == 6) { hseg(1.8); vseg(-1.25,0.15); hseg(0); vseg(0.85,-1.65); vseg(-1.25,-1.65); hseg(-1.8); }
    if (d == 7) { hseg(1.8); vseg(0.85,0.15); vseg(0.85,-1.65); }
    if (d == 8) { hseg(1.8); vseg(0.85,0.15); vseg(0.85,-1.65); hseg(-1.8); vseg(-1.25,-1.65); vseg(-1.25,0.15); hseg(0); }
    if (d == 9) { hseg(1.8); vseg(0.85,0.15); vseg(0.85,-1.65); hseg(-1.8); vseg(-1.25,0.15); hseg(0); }
}

module raised_cam_number() {
    translate([-1.55, -13.2, 0]) digit_segments(1);
    translate([ 1.55, -13.2, 0]) digit_segments(2);
}

module raised_stitch_preview() {
            translate([-4.0940, 12.3200, disc_thickness])
                rotate([0,0,-57.0278])
                    cube(size=[1.8595, 0.7000, 0.8000], center=false);
            translate([-3.0590, 11.3840, disc_thickness])
                rotate([0,0,-16.4306])
                    cube(size=[1.1030, 0.7000, 0.8000], center=false);
            translate([-1.9090, 11.9560, disc_thickness])
                rotate([0,0,49.5351])
                    cube(size=[1.9138, 0.7000, 0.8000], center=false);
            translate([-0.6440, 13.8280, disc_thickness])
                rotate([0,0,60.6232])
                    cube(size=[2.6256, 0.7000, 0.8000], center=false);
            translate([0.6440, 13.8280, disc_thickness])
                rotate([0,0,-60.6232])
                    cube(size=[2.6256, 0.7000, 0.8000], center=false);
            translate([1.9090, 11.9560, disc_thickness])
                rotate([0,0,-49.5351])
                    cube(size=[1.9138, 0.7000, 0.8000], center=false);
            translate([3.0590, 11.3840, disc_thickness])
                rotate([0,0,16.4306])
                    cube(size=[1.1030, 0.7000, 0.8000], center=false);
            translate([4.0940, 12.3200, disc_thickness])
                rotate([0,0,57.0278])
                    cube(size=[1.8595, 0.7000, 0.8000], center=false);
}

module elna_single_cam_12() {
    difference() {
        union() {
            // body
            cylinder(h = disc_thickness, r = body_radius);
            cylinder(h = disc_thickness, r = outer_reference_radius);

            // lower cam contour
            linear_extrude(height = lobe_thickness)
                lobe_profile();

            // visible raised labels
            raised_cam_number();
            raised_stitch_preview();
        }

        // Main shaft hole
        translate([0, 0, disc_thickness / 2])
            cylinder(h = disc_thickness + label_height + 1, r = inner_hole_rad, center = true);

        // Lower widened hole
        translate([0, 0, -cut_errors])
            cylinder(h = bigger_hole_ht + cut_errors, r = hole_bigger_rad);

        // Taper from widened hole to main hole
        translate([0, 0, bigger_hole_ht - cut_errors])
            cylinder(h = hole_cone_ht, r1 = hole_bigger_rad, r2 = inner_hole_rad);

        // Transport slot
        translate([0, hole_bigger_rad + gap_to_transporthole + transporthole_length / 2,
                   transporthole_depth / 2 - cut_errors])
            cube(size = [transporthole_width, transporthole_length, transporthole_depth + label_height + 1], center = true);
    }
}

elna_single_cam_12();
