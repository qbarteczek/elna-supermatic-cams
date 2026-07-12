/*
  Elna Supermatic single cam — measured parametric base v1.

  Dimensions are read from the uploaded STL/SCAD reference files:
  - ElnaSupermaticZizagCamWhole.stl
  - ElnaSupermaticZizagCam3NoBottomRing.stl
  - ElnaSupermaticZizagCamWhole.scad

  Fixed:
  - body height,
  - central hole,
  - lower counterbore/cone,
  - transport slot,
  - top circular body/ring style.

  Variable:
  - lower functional cam edge,
  - number,
  - stitch pictogram.

  License: GPL-3.0-or-later.
*/

$fn = 128;

overall_r = 21.8200;
body_r = 18.5500;
total_h = 7.3080;
body_top_h = 6.9990;
label_h = 0.3090;
lobe_h = 4.4990;

center_hole_r = 8.2500;
counterbore_r = 9.5000;
counterbore_h = 1.5000;
cone_h = 1.5000;

transport_w = 3.0000;
transport_len = 4.1000;
transport_depth = 5.5000;
transport_gap = 1.0000;

cut_eps = 0.08;

module annulus(h, ro, ri) {
    difference() {
        cylinder(h=h, r=ro);
        translate([0,0,-cut_eps]) cylinder(h=h+2*cut_eps, r=ri);
    }
}

module base_body(profile_points) {
    union() {
        // Lower functional cam shape, only this outer edge changes between cams.
        linear_extrude(height=lobe_h)
            polygon(points=profile_points);

        // Upper circular body, preserves Elna-style disc shape.
        cylinder(h=body_top_h, r=body_r);

        // Very thin top reference rim, matching the visual ring from the scan.
        translate([0,0,body_top_h-0.22])
            annulus(h=0.22, ro=body_r+0.10, ri=body_r-0.45);

        // Inner raised/counter ring visible around main hole.
        translate([0,0,body_top_h-0.45])
            annulus(h=0.45, ro=center_hole_r+2.05, ri=center_hole_r+0.35);
    }
}

module holes_and_slots() {
    // Main shaft hole.
    translate([0,0,-cut_eps])
        cylinder(h=total_h+2*cut_eps, r=center_hole_r);

    // Lower widened bore.
    translate([0,0,-cut_eps])
        cylinder(h=counterbore_h+cut_eps, r=counterbore_r);

    // Taper from lower bore to main hole.
    translate([0,0,counterbore_h-cut_eps])
        cylinder(h=cone_h, r1=counterbore_r, r2=center_hole_r);

    // Transport / locating slot. This is fixed, not variable.
    translate([0, counterbore_r + transport_gap + transport_len/2,
               transport_depth/2 - cut_eps])
        cube(size=[transport_w, transport_len, transport_depth], center=true);
}

module raised_stroke_path(points=[[0,0],[1,1]], pos=[0,0], scale_xy=[1,1], width=0.46, height=label_h) {
    module node(p) {
        translate([pos[0] + p[0]*scale_xy[0], pos[1] + p[1]*scale_xy[1], body_top_h])
            cylinder(h=height, r=width/2, $fn=18);
    }
    for (i=[0:len(points)-2]) {
        hull() {
            node(points[i]);
            node(points[i+1]);
        }
    }
}

module top_markings(number_text="03", icon_points=[[0,0],[1,1]]) {
    // Number badge like original Elna layout.
    translate([11.55,-7.25,body_top_h])
        annulus(h=label_h, ro=2.95, ri=2.35);

    translate([11.55,-7.25,body_top_h])
        linear_extrude(height=label_h)
            text(number_text, size=3.25, halign="center", valign="center",
                 font="Liberation Sans:style=Bold");

    // Blank circular badge on opposite side, visually matching reference.
    translate([-11.80,-7.25,body_top_h])
        annulus(h=label_h, ro=2.80, ri=2.20);

    // Stitch pictogram — fixed place, changed per cam.
    raised_stroke_path(points=icon_points, pos=[0,-11.65], scale_xy=[7.50,2.45], width=0.44, height=label_h);

    // Small Swiss/Made marks, fixed styling.
    translate([-14.35,0.80,body_top_h])
        rotate([0,0,90])
            linear_extrude(height=label_h)
                text("SWISS", size=2.1, halign="center", valign="center",
                     font="Liberation Sans:style=Bold");

    translate([0.0,-15.15,body_top_h])
        linear_extrude(height=label_h)
            text("MADE", size=2.0, halign="center", valign="center",
                 font="Liberation Sans:style=Bold");

    // Small pips along lower arc — fixed visual detail.
    for (a=[208:10:332]) {
        rotate([0,0,a])
            translate([body_r-0.55,0,body_top_h])
                cube([0.62,0.34,label_h], center=true);
    }
}

module elna_single_cam(profile_points, icon_points, number_text="03") {
    difference() {
        union() {
            base_body(profile_points);
            top_markings(number_text=number_text, icon_points=icon_points);
        }
        holes_and_slots();
    }
}
