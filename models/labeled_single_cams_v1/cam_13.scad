/*
  Elna Supermatic single cam 13
  Name: Source profile 13
  Status: source-profile
  Visible raised number and stitch preview.

  IMPORTANT:
  Labels are raised geometry, not engraved text. They should be visible in render and print.
  Cam profile is still source-derived.

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
        [-1.9169, 19.9079],
        [1.9169, 19.9079],
        [4.6320, 17.9107],
        [7.9645, 16.6978],
        [11.3281, 16.4825],
        [14.2650, 14.0182],
        [15.0611, 10.7430],
        [16.8343, 7.6718],
        [19.2726, 5.3448],
        [19.9383, 1.5692],
        [18.4430, -1.4515],
        [17.8272, -4.9439],
        [18.1992, -8.2939],
        [16.2823, -11.6141],
        [13.1951, -12.9668],
        [10.4785, -15.2463],
        [8.6102, -18.0517],
        [5.0076, -19.3630],
        [1.9169, -19.9079],
        [-1.9169, -19.9079],
        [-5.3832, -20.8152],
        [-9.2560, -19.4056],
        [-11.3281, -16.4825],
        [-14.2650, -14.0182],
        [-17.5035, -12.4851],
        [-19.5642, -8.9159],
        [-19.2726, -5.3448],
        [-19.9383, -1.5692],
        [-21.4337, 1.6869],
        [-20.7181, 5.7456],
        [-18.1992, 8.2939],
        [-16.2823, 11.6141],
        [-15.3349, 15.0695],
        [-12.1777, 17.7187],
        [-8.6102, 18.0517],
        [-5.0076, 19.3630]
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
    translate([ 1.55, -13.2, 0]) digit_segments(3);
}

module raised_stitch_preview() {
            translate([-4.0250, 11.5400, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
            translate([-3.4500, 12.0600, disc_thickness])
                rotate([0,0,90.0000])
                    cube(size=[1.0400, 0.7000, 0.8000], center=false);
            translate([-2.8750, 12.5800, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
            translate([-2.3000, 13.1000, disc_thickness])
                rotate([0,0,90.0000])
                    cube(size=[1.0400, 0.7000, 0.8000], center=false);
            translate([-1.7250, 13.6200, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
            translate([-1.1500, 14.1400, disc_thickness])
                rotate([0,0,90.0000])
                    cube(size=[1.0400, 0.7000, 0.8000], center=false);
            translate([-0.5750, 14.6600, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
            translate([0.0000, 14.1400, disc_thickness])
                rotate([0,0,-90.0000])
                    cube(size=[1.0400, 0.7000, 0.8000], center=false);
            translate([0.5750, 13.6200, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
            translate([1.1500, 13.1000, disc_thickness])
                rotate([0,0,-90.0000])
                    cube(size=[1.0400, 0.7000, 0.8000], center=false);
            translate([1.7250, 12.5800, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
            translate([2.3000, 12.0600, disc_thickness])
                rotate([0,0,-90.0000])
                    cube(size=[1.0400, 0.7000, 0.8000], center=false);
            translate([2.8750, 11.5400, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
            translate([3.4500, 12.0600, disc_thickness])
                rotate([0,0,90.0000])
                    cube(size=[1.0400, 0.7000, 0.8000], center=false);
            translate([4.0250, 12.5800, disc_thickness])
                rotate([0,0,0.0000])
                    cube(size=[1.1500, 0.7000, 0.8000], center=false);
}

module elna_single_cam_13() {
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

elna_single_cam_13();
