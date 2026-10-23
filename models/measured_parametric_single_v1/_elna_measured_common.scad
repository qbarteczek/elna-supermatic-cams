/*
  Elna Supermatic single cam — measured parametric base v3.

  Dimensions from uploaded STL/SCAD reference files:
    ElnaSupermaticZizagCamWhole.stl
    ElnaSupermaticZizagCam3NoBottomRing.stl
    ElnaSupermaticZizagCamWhole.scad

  v3 changes vs v2:
    - Top face is FLAT again (like the reference STL: 6.999 mm + 0.309 mm markings
      = 7.308 mm). The v2 dome raised the disc to 8.8 mm. The dome is still
      available: set dome_crown > 0.
    - Markings no longer float: they are cut to the real top surface
      (flat or dome), so they always sit on the disc.
    - Layout follows the reference disc: "SWISS MADE" along the arc next to the
      transport slot with a ring marking the slot, number medallion, blank
      medallion, pictogram on the opposite side, 18 step notches on the rim.
    - Body and ring really split at ring_h: the body starts at z = ring_h
      (cam lobe from ring_h, like the reference), the universal ring fills
      z = 0 .. ring_h. Glued together they give exactly the assembly.
      (v2 body already contained the bottom 1.2 mm, so body + ring was 1.2 mm too tall.)
    - Removed the inner ring around the hole (hidden inside the body)
      and the 0.1 mm overhanging rim lip.
    - elna_profile_points() and elna_icon_points() — the same profile math
      as tools/generate_cam.py and index.html.

  Fixed geometry:
    - body height, central hole, lower counterbore/cone,
      transport slot, top face.

  Variable per cam:
    - lower functional cam edge (profile_points),
    - number text,
    - stitch pictogram (icon_points).

  Orientation: the transport slot is on +Y. Profile angle 0 = slot direction,
  angles grow clockwise seen from the top.

  Print workflow:
    1. cam_XX_body.stl — body, flat bottom on the bed, markings up, no supports.
    2. universal_ring.stl — the same ring for every cam, print flat.
    3. Glue the ring under the body (slot holes aligned).
    (cam_XX.stl = assembly in one piece; needs supports under the cam lobe.)

  License: GPL-3.0-or-later.
*/

$fn = 128;

// ── Fixed dimensions ────────────────────────────────────────────────────
overall_r        = 21.8200;  // max functional lobe radius
body_r           = 18.5500;  // upper body / base lobe radius
total_h          = 7.3080;   // total disc height (flat top + markings)
body_top_h       = 6.9990;   // height of the top face
label_h          = 0.3090;   // raised marking height above the top face
throw            = 3.2700;   // lobe throw: overall_r - body_r

lobe_h           = 4.4990;   // top of the lower functional lobe

// Optional dome (v2 style). 0 = flat top like the original disc.
dome_crown       = 0.0;
dome_r_sphere    = dome_crown > 0 ? (body_r*body_r + dome_crown*dome_crown) / (2*dome_crown) : 0;
dome_base_z      = body_top_h - (dome_r_sphere - dome_crown);

// Bottom ring (separate printable element, the same for all cams)
ring_h           = 1.2000;

// Central hole and counterbore
center_hole_r    = 8.2500;
counterbore_r    = 9.5000;
counterbore_h    = 1.5000;
cone_h           = 1.5000;

// Transport / locating slot (on +Y)
transport_w      = 3.0000;
transport_len    = 4.1000;
transport_depth  = 5.5000;
transport_gap    = 1.0000;

// Step notches on the top rim (one per step, every 20 deg, step centres)
step_notch_w     = 0.8000;
step_notch_len   = 1.0000;
step_notch_depth = 0.5000;

// Marking layout (mm, top view, slot on +Y)
number_pos       = [11.55, -7.25];
blank_pos        = [-11.80, -7.25];
icon_pos         = [0.00, -11.65];
icon_scale       = [7.50, 2.45];
icon_stroke      = 0.50;
slot_mark_r      = 13.20;   // ring above the transport slot
arc_text_r       = 13.10;   // baseline radius of "SWISS MADE"
arc_text_size    = 1.90;
marking_font     = "Liberation Sans:style=Bold";

cut_eps          = 0.08;

// ── Profile and pictogram data (same math as tools/generate_cam.py) ─────

function elna_clamp3(v) = max(0, min(3, v));
function elna_radius(v) = body_r + (elna_clamp3(v) / 3.0) * throw;

// 18 values 0..3 -> polygon of the cam lobe.
// stepped: constant-radius dwell (arc) +-7 deg around 20*i, straight ramps;
// smooth: cosine interpolation every 2 deg.
function elna_profile_points(values, mode="smooth") =
    (mode == "stepped") ?
        [for (i = [0:17])
            let (r = elna_radius(values[i]), c = i * 20)
            each [for (k = [0:7]) let (a = c - 7 + 2 * k) [r * sin(a), r * cos(a)]]]
    :
        [for (deg = [0:2:358])
            let (fi = deg / 20,
                 i0 = floor(fi) % 18,
                 i1 = (i0 + 1) % 18,
                 t  = fi - floor(fi),
                 ts = (1 - cos(t * 180)) / 2,
                 v  = elna_clamp3(values[i0]) * (1 - ts) + elna_clamp3(values[i1]) * ts,
                 r  = body_r + (v / 3.0) * throw)
            [r * sin(deg), r * cos(deg)]];

// <generated:icons> — written by tools/regenerate_scad.py, do not edit by hand
function elna_icon_points(kind) =
    (kind == "zigzag") ? [[-1.0,0.04],[-0.889,0.96],[-0.778,0.04],[-0.667,0.96],[-0.556,0.04],[-0.444,0.96],[-0.333,0.04],[-0.222,0.96],[-0.111,0.04],[0.0,0.96],[0.111,0.04],[0.222,0.96],[0.333,0.04],[0.444,0.96],[0.556,0.04],[0.667,0.96],[0.778,0.04],[0.889,0.96],[1.0,0.04]] :
    (kind == "step") ? [[-1.0,0.18],[-0.82,0.18],[-0.82,0.36],[-0.64,0.36],[-0.64,0.56],[-0.46,0.56],[-0.46,0.74],[-0.28,0.74],[-0.28,0.56],[-0.1,0.56],[-0.1,0.36],[0.08,0.36],[0.08,0.18],[0.26,0.18],[0.26,0.36],[0.44,0.36],[0.44,0.56],[0.62,0.56],[0.62,0.74],[0.8,0.74],[1.0,0.74]] :
    (kind == "wave") ? [[-1.0,0.5],[-0.956,0.599],[-0.911,0.691],[-0.867,0.768],[-0.822,0.824],[-0.778,0.855],[-0.733,0.858],[-0.689,0.834],[-0.644,0.784],[-0.6,0.712],[-0.556,0.623],[-0.511,0.525],[-0.467,0.425],[-0.422,0.331],[-0.378,0.25],[-0.333,0.188],[-0.289,0.151],[-0.244,0.14],[-0.2,0.158],[-0.156,0.202],[-0.111,0.269],[-0.067,0.354],[-0.022,0.45],[0.022,0.55],[0.067,0.646],[0.111,0.731],[0.156,0.798],[0.2,0.842],[0.244,0.86],[0.289,0.849],[0.333,0.812],[0.378,0.75],[0.422,0.669],[0.467,0.575],[0.511,0.475],[0.556,0.377],[0.6,0.288],[0.644,0.216],[0.689,0.166],[0.733,0.142],[0.778,0.145],[0.822,0.176],[0.867,0.232],[0.911,0.309],[0.956,0.401],[1.0,0.5]] :
    (kind == "scallop") ? [[-1.0,0.1],[-0.959,0.257],[-0.918,0.408],[-0.878,0.547],[-0.837,0.67],[-0.796,0.773],[-0.755,0.85],[-0.714,0.899],[-0.673,0.92],[-0.633,0.909],[-0.592,0.87],[-0.551,0.801],[-0.51,0.707],[-0.469,0.59],[-0.429,0.456],[-0.388,0.308],[-0.347,0.153],[-0.306,0.205],[-0.265,0.358],[-0.224,0.502],[-0.184,0.632],[-0.143,0.741],[-0.102,0.827],[-0.061,0.886],[-0.02,0.916],[0.02,0.916],[0.061,0.886],[0.102,0.827],[0.143,0.741],[0.184,0.632],[0.224,0.502],[0.265,0.358],[0.306,0.205],[0.347,0.153],[0.388,0.308],[0.429,0.456],[0.469,0.59],[0.51,0.707],[0.551,0.801],[0.592,0.87],[0.633,0.909],[0.673,0.92],[0.714,0.899],[0.755,0.85],[0.796,0.773],[0.837,0.67],[0.878,0.547],[0.918,0.408],[0.959,0.257],[1.0,0.1]] :
    (kind == "saw") ? [[-1.0,0.18],[-0.75,0.82],[-0.5,0.18],[-0.25,0.82],[0.0,0.18],[0.25,0.82],[0.5,0.18],[0.75,0.82],[1.0,0.18]] :
    (kind == "blind") ? [[-1.0,0.18],[-0.82,0.18],[-0.64,0.18],[-0.46,0.18],[-0.3,0.72],[-0.14,0.18],[0.02,0.18],[0.2,0.18],[0.38,0.18],[0.54,0.72],[0.7,0.18],[1.0,0.18]] :
    (kind == "arrows") ? [[-1.0,0.18],[-0.86,0.18],[-0.74,0.74],[-0.62,0.18],[-0.48,0.18],[-0.36,0.74],[-0.24,0.18],[-0.1,0.18],[0.02,0.74],[0.14,0.18],[0.28,0.18],[0.4,0.74],[0.52,0.18],[0.66,0.18],[0.78,0.74],[0.9,0.18],[1.0,0.18]] :
    (kind == "spindle") ? [[-1.0,0.5],[-0.8,0.2],[-0.56,0.12],[-0.34,0.3],[-0.16,0.64],[0.0,0.88],[0.16,0.64],[0.34,0.3],[0.56,0.12],[0.8,0.2],[1.0,0.5]] :
    (kind == "pulse") ? [[-1.0,0.2],[-0.88,0.62],[-0.76,0.86],[-0.64,0.62],[-0.52,0.2],[-0.3,0.2],[-0.18,0.62],[-0.06,0.86],[0.06,0.62],[0.18,0.2],[0.4,0.2],[0.52,0.62],[0.64,0.86],[0.76,0.62],[0.88,0.2],[1.0,0.2]] :
    (kind == "comb") ? [[-1.0,0.18],[-0.92,0.82],[-0.84,0.18],[-0.778,0.18],[-0.698,0.82],[-0.618,0.18],[-0.556,0.18],[-0.476,0.82],[-0.396,0.18],[-0.333,0.18],[-0.253,0.82],[-0.173,0.18],[-0.111,0.18],[-0.031,0.82],[0.049,0.18],[0.111,0.18],[0.191,0.82],[0.271,0.18],[0.333,0.18],[0.413,0.82],[0.493,0.18],[0.556,0.18],[0.636,0.82],[0.716,0.18],[0.778,0.18],[0.858,0.82],[0.938,0.18],[1.0,0.18]] :
    (kind == "hi-lo") ? [[-1.0,0.18],[-0.78,0.84],[-0.56,0.18],[-0.34,0.64],[-0.12,0.18],[0.1,0.56],[0.32,0.18],[0.54,0.46],[0.76,0.18],[1.0,0.38]] :
    [[-1.0,0.04],[-0.889,0.96],[-0.778,0.04],[-0.667,0.96],[-0.556,0.04],[-0.444,0.96],[-0.333,0.04],[-0.222,0.96],[-0.111,0.04],[0.0,0.96],[0.111,0.04],[0.222,0.96],[0.333,0.04],[0.444,0.96],[0.556,0.04],[0.667,0.96],[0.778,0.04],[0.889,0.96],[1.0,0.04]];
// </generated:icons>

// ── Helper modules ──────────────────────────────────────────────────────

module annulus(h, ro, ri) {
    difference() {
        cylinder(h=h, r=ro);
        translate([0, 0, -cut_eps]) cylinder(h=h+2*cut_eps, r=ri);
    }
}

module body_cylinder(h) {
    rotate([0, 0, 180 / $fn]) cylinder(h=h, r=body_r);
}

module ring_2d(ro, ri) {
    difference() { circle(r=ro); circle(r=ri); }
}

// Dome cap — sphere segment above body_top_h (only when dome_crown > 0)
module dome_cap() {
    if (dome_crown > 0)
        intersection() {
            translate([0, 0, dome_base_z])
                sphere(r=dome_r_sphere, $fn=360);
            translate([0, 0, body_top_h - cut_eps])
                cylinder(h=dome_crown + 2*cut_eps, r=body_r);
        }
}

// Everything below the top surface lifted by `lift` (used to trim markings
// so they follow the real top face — flat or domed).
module below_top_surface(lift=0) {
    cylinder(h=body_top_h + lift, r=body_r + 1);
    if (dome_crown > 0)
        intersection() {
            translate([0, 0, dome_base_z])
                sphere(r=dome_r_sphere + lift, $fn=360);
            cylinder(h=body_top_h + dome_crown + lift + 1, r=body_r + 1);
        }
}

// ── Structural body (from z = ring_h up, no ring) ───────────────────────

module base_body_no_ring(profile_points) {
    union() {
        // Lower functional cam lobe — only this outer edge changes per cam.
        translate([0, 0, ring_h])
            linear_extrude(height=lobe_h - ring_h)
                polygon(points=profile_points);

        // Upper circular body (turned by half a facet so its vertices never
        // coincide with profile points lying exactly on body_r).
        translate([0, 0, ring_h])
            body_cylinder(h=body_top_h - ring_h);

        // Optional dome.
        dome_cap();
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

// 18 small notches on the top rim, one per step (step centres, 20 deg apart).
module step_notches() {
    for (i = [0:17])
        rotate([0, 0, -20 * i])
            translate([-step_notch_w/2, body_r - step_notch_len, body_top_h - step_notch_depth])
                cube([step_notch_w, step_notch_len + 1, step_notch_depth + dome_crown + 1]);
}

// ── Top markings ────────────────────────────────────────────────────────

module stroke_2d(points, pos=[0,0], scale_xy=[1,1], width=0.5) {
    for (i = [0:len(points)-2])
        hull() {
            translate([pos[0] + points[i][0]*scale_xy[0],   pos[1] + points[i][1]*scale_xy[1]])
                circle(d=width, $fn=16);
            translate([pos[0] + points[i+1][0]*scale_xy[0], pos[1] + points[i+1][1]*scale_xy[1]])
                circle(d=width, $fn=16);
        }
}

// Approximate advance widths (em) of Liberation Sans Bold capitals.
function glyph_w(c) =
    (c == "I") ? 0.30 : (c == "W") ? 0.94 : (c == "M") ? 0.83 :
    (c == "A" || c == "D") ? 0.72 : 0.67;
function text_w(s, i=0) = (i >= len(s)) ? 0 : glyph_w(s[i]) + text_w(s, i+1);
function text_w_to(s, n) = (n <= 0) ? 0 : glyph_w(s[n-1]) + text_w_to(s, n-1);

// Text along a circle, letters upright seen from outside the disc,
// reading left to right. start_deg = clockwise angle from +Y of the first letter edge.
module arc_text_2d(s, r, size, start_deg, spacing=1.15) {
    em = size * spacing;
    for (i = [0:len(s)-1]) {
        a = start_deg + (text_w_to(s, i) + glyph_w(s[i]) / 2) * em / r * 180 / PI;
        rotate([0, 0, -a])
            translate([0, r])
                text(s[i], size=size, halign="center", valign="baseline", font=marking_font);
    }
}

function arc_text_span_deg(s, r, size, spacing=1.15) = text_w(s) * size * spacing / r * 180 / PI;

module markings_2d(number_text="03", icon_points=[[0,0],[1,1]]) {
    // Number medallion
    translate(number_pos) ring_2d(2.95, 2.40);
    n_size = (len(number_text) <= 2) ? 2.6 : 2.6 * 2 / len(number_text);
    translate(number_pos)
        text(number_text, size=n_size, halign="center", valign="center", font=marking_font);

    // Blank medallion opposite
    translate(blank_pos) ring_2d(2.80, 2.25);

    // Stitch pictogram (opposite the slot)
    stroke_2d(icon_points, pos=icon_pos, scale_xy=icon_scale, width=icon_stroke);

    // Ring over the transport slot + "SWISS" / "MADE" on both sides of it
    translate([0, slot_mark_r]) ring_2d(1.35, 0.85);
    gap = 8.5;
    arc_text_2d("SWISS", arc_text_r, arc_text_size,
                -gap - arc_text_span_deg("SWISS", arc_text_r, arc_text_size));
    arc_text_2d("MADE", arc_text_r, arc_text_size, gap);
}

// Raised markings that sit exactly on the top face (flat or dome).
module top_markings(number_text="03", icon_points=[[0,0],[1,1]]) {
    intersection() {
        translate([0, 0, body_top_h - 1])
            linear_extrude(height=1 + dome_crown + label_h + 1)
                markings_2d(number_text=number_text, icon_points=icon_points);
        below_top_surface(lift=label_h);
    }
}

// ── Public API ───────────────────────────────────────────────────────────

// Body + markings in assembly coordinates (z = ring_h .. top)
module elna_cam_body_in_place(profile_points, icon_points, number_text="03") {
    difference() {
        union() {
            base_body_no_ring(profile_points=profile_points);
            top_markings(number_text=number_text, icon_points=icon_points);
        }
        holes_and_slots();
        step_notches();
    }
}

// Full assembly — body and ring as one piece (preview, reference, resin print)
module elna_single_cam(profile_points, icon_points, number_text="03") {
    difference() {
        union() {
            base_body_no_ring(profile_points=profile_points);
            body_cylinder(h=ring_h + cut_eps);
            top_markings(number_text=number_text, icon_points=icon_points);
        }
        holes_and_slots();
        step_notches();
    }
}

// Body only — print this part (glue universal_ring to the bottom).
// Moved down so it stands on z = 0.
module elna_cam_body(profile_points, icon_points, number_text="03") {
    translate([0, 0, -ring_h])
        elna_cam_body_in_place(profile_points, icon_points, number_text);
}

// Universal ring — one bottom ring for ALL cams (01-34)
module universal_ring() {
    difference() {
        body_cylinder(h=ring_h);
        holes_and_slots();
    }
}

// Kept for compatibility with older files.
module elna_cam_ring(profile_points) {
    universal_ring();
}
