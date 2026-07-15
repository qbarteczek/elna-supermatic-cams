/*
  Elna Supermatic single cam — measured parametric base v2.

  Dimensions from uploaded STL/SCAD reference files:
    ElnaSupermaticZizagCamWhole.stl
    ElnaSupermaticZizagCam3NoBottomRing.stl
    ElnaSupermaticZizagCamWhole.scad

  v2 changes vs v1:
    - Bottom ring (rant) is a SEPARATE printable element (ring_only module).
    - Top surface is a gentle dome (~1.5 mm crown) instead of flat cylinder.
    - New module layout:
        base_body_no_ring()  — lobe + domed upper body, no bottom ring
        ring_only()          — thin bottom ring, print separately & glue
        elna_single_cam()    — full assembly for preview/reference (unchanged API)

  Fixed geometry:
    - body height, central hole, lower counterbore/cone,
      transport slot, top dome style.

  Variable per cam:
    - lower functional cam edge (profile_points),
    - number text,
    - stitch pictogram (icon_points).

  Print workflow:
    1. Render cam_XX.scad → export cam_XX_body.stl  (use base_body_no_ring)
    2. Render cam_XX_ring.scad (or use ring_only module) → cam_XX_ring.stl
    3. Print both, glue ring to body bottom with superglue.

  License: GPL-3.0-or-later.
*/

$fn = 128;

// ── Fixed dimensions ────────────────────────────────────────────────────
overall_r        = 21.8200;  // max functional lobe radius
body_r           = 18.5500;  // upper body / base lobe radius
total_h          = 7.3080;   // total disc height
body_top_h       = 6.9990;   // height to top surface start
label_h          = 0.3090;   // raised marking height above top

lobe_h           = 4.4990;   // lower functional lobe height

// Dome parameters (v2 — lekko wypukły wierzch)
dome_crown       = 1.5000;   // max dome height at centre above body_top_h
// Computed sphere radius for given crown and body_r:
// r_sphere = (body_r^2 + dome_crown^2) / (2*dome_crown)
dome_r_sphere    = (body_r*body_r + dome_crown*dome_crown) / (2*dome_crown);
dome_base_z      = body_top_h - (dome_r_sphere - dome_crown);

// Bottom ring / rant (v2 — separate element)
ring_h           = 1.2000;   // ring height (matches lower part of lobe)
ring_r_outer     = overall_r; // outer matches max lobe radius
ring_r_inner     = body_r;    // inner = body cylinder radius
// The ring sits at z=0 (very bottom of disc)

// Central hole and counterbore
center_hole_r    = 8.2500;
counterbore_r    = 9.5000;
counterbore_h    = 1.5000;
cone_h           = 1.5000;

// Transport / locating slot
transport_w      = 3.0000;
transport_len    = 4.1000;
transport_depth  = 5.5000;
transport_gap    = 1.0000;

cut_eps          = 0.08;

// ── Helper modules ──────────────────────────────────────────────────────

module annulus(h, ro, ri) {
    difference() {
        cylinder(h=h, r=ro);
        translate([0, 0, -cut_eps]) cylinder(h=h+2*cut_eps, r=ri);
    }
}

// Dome cap — sphere-segment above body_top_h
module dome_cap() {
    intersection() {
        translate([0, 0, dome_base_z])
            sphere(r=dome_r_sphere, $fn=128);
        // Only the part above body_top_h and within body_r
        translate([0, 0, body_top_h])
            cylinder(h=dome_crown + cut_eps, r=body_r);
    }
}

// ── Structural body (no ring) ───────────────────────────────────────────

module base_body_no_ring(profile_points) {
    union() {
        // Lower functional cam lobe — only this outer edge changes per cam.
        // Starts at z=ring_h so the ring slot is clean.
        translate([0, 0, ring_h])
            linear_extrude(height=lobe_h - ring_h)
                polygon(points=profile_points);

        // Upper circular body — preserves Elna-style disc.
        cylinder(h=body_top_h, r=body_r);

        // Dome top surface (v2)
        dome_cap();

        // Very thin reference rim at top edge.
        translate([0, 0, body_top_h - 0.22])
            annulus(h=0.22, ro=body_r+0.10, ri=body_r-0.45);

        // Inner raised ring around main hole.
        translate([0, 0, body_top_h - 0.45])
            annulus(h=0.45, ro=center_hole_r+2.05, ri=center_hole_r+0.35);
    }
}

// ── Bottom ring (rant) — separate printable element ─────────────────────

module ring_only(profile_points) {
    // Ring follows the outer functional lobe profile at bottom
    // Inner wall is the body_r cylinder
    difference() {
        union() {
            // Outer ring shell follows lobe profile
            linear_extrude(height=ring_h)
                polygon(points=profile_points);
            // Inner fill to body_r (so it glues flush)
            cylinder(h=ring_h, r=body_r);
        }
        // Hollow center (shaft hole)
        translate([0, 0, -cut_eps])
            cylinder(h=ring_h + 2*cut_eps, r=center_hole_r);
        // Lower widened bore
        translate([0, 0, -cut_eps])
            cylinder(h=counterbore_h + cut_eps, r=counterbore_r);
        // Taper from bore to hole
        translate([0, 0, counterbore_h - cut_eps])
            cylinder(h=cone_h, r1=counterbore_r, r2=center_hole_r);
        // Transport slot passes through ring too
        translate([0, counterbore_r + transport_gap + transport_len/2,
                   transport_depth/2 - cut_eps])
            cube(size=[transport_w, transport_len, transport_depth], center=true);
    }
}

// ── Shared hole/slot cutter ─────────────────────────────────────────────

module holes_and_slots() {
    // Main shaft hole
    translate([0, 0, -cut_eps])
        cylinder(h=total_h + dome_crown + 2*cut_eps, r=center_hole_r);

    // Lower widened bore
    translate([0, 0, -cut_eps])
        cylinder(h=counterbore_h + cut_eps, r=counterbore_r);

    // Taper from bore to hole
    translate([0, 0, counterbore_h - cut_eps])
        cylinder(h=cone_h, r1=counterbore_r, r2=center_hole_r);

    // Transport slot
    translate([0, counterbore_r + transport_gap + transport_len/2,
               transport_depth/2 - cut_eps])
        cube(size=[transport_w, transport_len, transport_depth], center=true);
}

// ── Top markings ────────────────────────────────────────────────────────

module raised_stroke_path(points=[[0,0],[1,1]], pos=[0,0], scale_xy=[1,1],
                          width=0.46, height=label_h) {
    module node(p) {
        translate([pos[0] + p[0]*scale_xy[0], pos[1] + p[1]*scale_xy[1],
                   body_top_h + dome_crown])
            cylinder(h=height, r=width/2, $fn=18);
    }
    for (i=[0:len(points)-2]) {
        hull() { node(points[i]); node(points[i+1]); }
    }
}

module top_markings(number_text="03", icon_points=[[0,0],[1,1]]) {
    top_z = body_top_h + dome_crown;

    // Number badge
    translate([11.55, -7.25, top_z])
        annulus(h=label_h, ro=2.95, ri=2.35);
    translate([11.55, -7.25, top_z])
        linear_extrude(height=label_h)
            text(number_text, size=3.25, halign="center", valign="center",
                 font="Liberation Sans:style=Bold");

    // Blank badge opposite side
    translate([-11.80, -7.25, top_z])
        annulus(h=label_h, ro=2.80, ri=2.20);

    // Stitch pictogram
    raised_stroke_path(points=icon_points, pos=[0,-11.65],
                       scale_xy=[7.50, 2.45], width=0.44, height=label_h);

    // "SWISS" mark
    translate([-14.35, 0.80, top_z])
        rotate([0, 0, 90])
            linear_extrude(height=label_h)
                text("SWISS", size=2.1, halign="center", valign="center",
                     font="Liberation Sans:style=Bold");

    // "MADE" mark
    translate([0.0, -15.15, top_z])
        linear_extrude(height=label_h)
            text("MADE", size=2.0, halign="center", valign="center",
                 font="Liberation Sans:style=Bold");

    // Small pips along lower arc
    for (a=[208:10:332]) {
        rotate([0, 0, a])
            translate([body_r - 0.55, 0, top_z])
                cube([0.62, 0.34, label_h], center=true);
    }
}

// ── Public API ───────────────────────────────────────────────────────────

// Full assembly — for OpenSCAD preview and reference rendering
module elna_single_cam(profile_points, icon_points, number_text="03") {
    difference() {
        union() {
            base_body_no_ring(profile_points=profile_points);
            ring_only(profile_points=profile_points);
            top_markings(number_text=number_text, icon_points=icon_points);
        }
        holes_and_slots();
    }
}

// Body only — print this part (glue ring to bottom)
module elna_cam_body(profile_points, icon_points, number_text="03") {
    difference() {
        union() {
            base_body_no_ring(profile_points=profile_points);
            top_markings(number_text=number_text, icon_points=icon_points);
        }
        holes_and_slots();
    }
}

// Ring only — print this separately, glue to cam body bottom
module elna_cam_ring(profile_points) {
    ring_only(profile_points=profile_points);
}
