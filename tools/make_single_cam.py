#!/usr/bin/env python3
# Generate a single-cam OpenSCAD file from an 18-token JSON profile.

from __future__ import annotations

import argparse
import json
from pathlib import Path

TOKEN_VALUES = {"l": 0.00, "cl": 0.75, "c": 1.50, "cr": 2.25, "r": 3.00}

SCAD_TEMPLATE = """/* 
  Elna Supermatic cam {cam_no}
  Generated from {profile_file}

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

module cam_{cam_no}() {{
    difference() {{
        union() {{
            cylinder(h = disc_thickness, r = thickest_cyl_rad);
            translate([0, 0, skirting])
                cylinder(h = disc_thickness - skirting * 2, r = thickest_cyl_rad + skirting_width);

            translate([0, 0, skirting])
                linear_extrude(height = lobe_thickness)
                    plotpoly({profile_args});

            translate([-5, -15, disc_thickness - 0.45])
                linear_extrude(height = 0.5)
                    text("{cam_no}", size = 5, halign = "center", valign = "center");
        }}

        translate([0, 0, disc_thickness / 2])
            cylinder(h = disc_thickness + 1, r = inner_hole_rad, center = true);

        translate([0, 0, -cut_errors])
            cylinder(h = bigger_hole_ht + cut_errors, r = hole_bigger_rad);

        translate([0, 0, bigger_hole_ht - cut_errors])
            cylinder(h = hole_cone_ht, r1 = hole_bigger_rad, r2 = inner_hole_rad);

        translate([0, hole_bigger_rad + gap_to_transporthole + transporthole_length / 2,
                   transporthole_depth / 2 - cut_errors])
            cube(size = [transporthole_width, transporthole_length, transporthole_depth], center = true);
    }}
}}

cam_{cam_no}();
"""

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("profile_json")
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    profile_path = Path(args.profile_json)
    data = json.loads(profile_path.read_text(encoding="utf-8"))

    tokens = data.get("profile_tokens")
    if not isinstance(tokens, list) or len(tokens) != 18:
        raise SystemExit("profile_tokens must contain exactly 18 items")

    invalid = [t for t in tokens if t not in TOKEN_VALUES]
    if invalid:
        raise SystemExit(f"Invalid tokens: {invalid}")

    cam_no = str(data.get("cam", "XX")).replace(" ", "_")
    scad = SCAD_TEMPLATE.format(
        cam_no=cam_no,
        profile_file=profile_path.name,
        profile_args=", ".join(tokens),
    )

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(scad, encoding="utf-8")
    print(f"Wrote {out}")

if __name__ == "__main__":
    main()
