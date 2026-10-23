#!/usr/bin/env python3
"""
Elna Supermatic Cam Generator CLI
Generates OpenSCAD models and JSON profile files for Elna Supermatic single cams
using measured parametric dimensions.

This module is also the single source of truth for the profile math and the
stitch pictograms. tools/regenerate_scad.py imports it and copies the same data
into the OpenSCAD library, the OpenSCAD Customizer and index.html.

Profile convention (identical in Python, OpenSCAD and JavaScript):
  - angle 0 deg points at the transport slot (+Y), angles grow clockwise
    seen from the top: point = [r*sin(a), r*cos(a)],
  - 18 steps of 20 deg; value i is centred on a = 20*i deg
    (the reference zigzag disc has its teeth centred on the slot direction),
  - stepped: constant-radius dwell (arc) +-7 deg around the centre,
    straight 6 deg ramp between steps,
  - smooth: cosine interpolation every 2 deg (never overshoots 0..3).

Usage:
  python tools/generate_cam.py --cam 03 --name "Zigzag reference" --values 0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3 --mode stepped --out models/generated/cam_03.scad
  python tools/generate_cam.py --profile models/measured_parametric_single_v1/profiles/cam_03_profile.json --out output.scad
"""

import argparse
import json
import math
import sys
from pathlib import Path

BASE_RADIUS = 18.550
OVERALL_RADIUS = 21.820
THROW = 3.270
TOTAL_HEIGHT = 7.308
BODY_TOP_HEIGHT = 6.999
LOBE_HEIGHT = 4.499
LABEL_HEIGHT = 0.309
RING_HEIGHT = 1.200

CENTER_HOLE_RADIUS = 8.250
COUNTERBORE_RADIUS = 9.500
COUNTERBORE_HEIGHT = 1.500
CONE_HEIGHT = 1.500

TRANSPORT_W = 3.000
TRANSPORT_LEN = 4.100
TRANSPORT_DEPTH = 5.500
TRANSPORT_GAP = 1.000

STEPS = 18
STEP_DEG = 360.0 / STEPS          # 20 deg
PLATEAU_HALF_DEG = 7.0            # flat part of a stepped lobe: +-7 deg
SMOOTH_SAMPLE_DEG = 2             # smooth profile: one point every 2 deg

# Stitch pictograms on the top face: polyline, x in -1..1, y in 0..1.
ICON_POINTS = {
    "zigzag": [[-1.0, 0.04], [-0.889, 0.96], [-0.778, 0.04], [-0.667, 0.96], [-0.556, 0.04], [-0.444, 0.96], [-0.333, 0.04], [-0.222, 0.96], [-0.111, 0.04], [0.0, 0.96], [0.111, 0.04], [0.222, 0.96], [0.333, 0.04], [0.444, 0.96], [0.556, 0.04], [0.667, 0.96], [0.778, 0.04], [0.889, 0.96], [1.0, 0.04]],
    "step": [[-1.0, 0.18], [-0.82, 0.18], [-0.82, 0.36], [-0.64, 0.36], [-0.64, 0.56], [-0.46, 0.56], [-0.46, 0.74], [-0.28, 0.74], [-0.28, 0.56], [-0.1, 0.56], [-0.1, 0.36], [0.08, 0.36], [0.08, 0.18], [0.26, 0.18], [0.26, 0.36], [0.44, 0.36], [0.44, 0.56], [0.62, 0.56], [0.62, 0.74], [0.8, 0.74], [1.0, 0.74]],
    "wave": [[-1.0, 0.5], [-0.956, 0.599], [-0.911, 0.691], [-0.867, 0.768], [-0.822, 0.824], [-0.778, 0.855], [-0.733, 0.858], [-0.689, 0.834], [-0.644, 0.784], [-0.6, 0.712], [-0.556, 0.623], [-0.511, 0.525], [-0.467, 0.425], [-0.422, 0.331], [-0.378, 0.25], [-0.333, 0.188], [-0.289, 0.151], [-0.244, 0.14], [-0.2, 0.158], [-0.156, 0.202], [-0.111, 0.269], [-0.067, 0.354], [-0.022, 0.45], [0.022, 0.55], [0.067, 0.646], [0.111, 0.731], [0.156, 0.798], [0.2, 0.842], [0.244, 0.86], [0.289, 0.849], [0.333, 0.812], [0.378, 0.75], [0.422, 0.669], [0.467, 0.575], [0.511, 0.475], [0.556, 0.377], [0.6, 0.288], [0.644, 0.216], [0.689, 0.166], [0.733, 0.142], [0.778, 0.145], [0.822, 0.176], [0.867, 0.232], [0.911, 0.309], [0.956, 0.401], [1.0, 0.5]],
    "scallop": [[-1.0, 0.1], [-0.959, 0.257], [-0.918, 0.408], [-0.878, 0.547], [-0.837, 0.67], [-0.796, 0.773], [-0.755, 0.85], [-0.714, 0.899], [-0.673, 0.92], [-0.633, 0.909], [-0.592, 0.87], [-0.551, 0.801], [-0.51, 0.707], [-0.469, 0.59], [-0.429, 0.456], [-0.388, 0.308], [-0.347, 0.153], [-0.306, 0.205], [-0.265, 0.358], [-0.224, 0.502], [-0.184, 0.632], [-0.143, 0.741], [-0.102, 0.827], [-0.061, 0.886], [-0.02, 0.916], [0.02, 0.916], [0.061, 0.886], [0.102, 0.827], [0.143, 0.741], [0.184, 0.632], [0.224, 0.502], [0.265, 0.358], [0.306, 0.205], [0.347, 0.153], [0.388, 0.308], [0.429, 0.456], [0.469, 0.59], [0.51, 0.707], [0.551, 0.801], [0.592, 0.87], [0.633, 0.909], [0.673, 0.92], [0.714, 0.899], [0.755, 0.85], [0.796, 0.773], [0.837, 0.67], [0.878, 0.547], [0.918, 0.408], [0.959, 0.257], [1.0, 0.1]],
    "saw": [[-1.0, 0.18], [-0.75, 0.82], [-0.5, 0.18], [-0.25, 0.82], [0.0, 0.18], [0.25, 0.82], [0.5, 0.18], [0.75, 0.82], [1.0, 0.18]],
    "blind": [[-1.0, 0.18], [-0.82, 0.18], [-0.64, 0.18], [-0.46, 0.18], [-0.3, 0.72], [-0.14, 0.18], [0.02, 0.18], [0.2, 0.18], [0.38, 0.18], [0.54, 0.72], [0.7, 0.18], [1.0, 0.18]],
    "arrows": [[-1.0, 0.18], [-0.86, 0.18], [-0.74, 0.74], [-0.62, 0.18], [-0.48, 0.18], [-0.36, 0.74], [-0.24, 0.18], [-0.1, 0.18], [0.02, 0.74], [0.14, 0.18], [0.28, 0.18], [0.4, 0.74], [0.52, 0.18], [0.66, 0.18], [0.78, 0.74], [0.9, 0.18], [1.0, 0.18]],
    "spindle": [[-1.0, 0.5], [-0.8, 0.2], [-0.56, 0.12], [-0.34, 0.3], [-0.16, 0.64], [0.0, 0.88], [0.16, 0.64], [0.34, 0.3], [0.56, 0.12], [0.8, 0.2], [1.0, 0.5]],
    "pulse": [[-1.0, 0.2], [-0.88, 0.62], [-0.76, 0.86], [-0.64, 0.62], [-0.52, 0.2], [-0.3, 0.2], [-0.18, 0.62], [-0.06, 0.86], [0.06, 0.62], [0.18, 0.2], [0.4, 0.2], [0.52, 0.62], [0.64, 0.86], [0.76, 0.62], [0.88, 0.2], [1.0, 0.2]],
    "comb": [[-1.0, 0.18], [-0.92, 0.82], [-0.84, 0.18], [-0.778, 0.18], [-0.698, 0.82], [-0.618, 0.18], [-0.556, 0.18], [-0.476, 0.82], [-0.396, 0.18], [-0.333, 0.18], [-0.253, 0.82], [-0.173, 0.18], [-0.111, 0.18], [-0.031, 0.82], [0.049, 0.18], [0.111, 0.18], [0.191, 0.82], [0.271, 0.18], [0.333, 0.18], [0.413, 0.82], [0.493, 0.18], [0.556, 0.18], [0.636, 0.82], [0.716, 0.18], [0.778, 0.18], [0.858, 0.82], [0.938, 0.18], [1.0, 0.18]],
    "hi-lo": [[-1.0, 0.18], [-0.78, 0.84], [-0.56, 0.18], [-0.34, 0.64], [-0.12, 0.18], [0.1, 0.56], [0.32, 0.18], [0.54, 0.46], [0.76, 0.18], [1.0, 0.38]],
}

ICON_LABELS_PL = {
    "zigzag": "Zygzak",
    "step": "Schodki / trójskok",
    "wave": "Płynna fala",
    "scallop": "Muszelka",
    "saw": "Piła / trójkąty",
    "blind": "Ścieg kryty",
    "arrows": "Strzałki",
    "spindle": "Wrzeciono",
    "pulse": "Impulsy",
    "comb": "Grzebyk",
    "hi-lo": "Wysoko-nisko",
}


def _clamp_value(v):
    return max(0.0, min(3.0, float(v)))


def _radius(v):
    return BASE_RADIUS + (_clamp_value(v) / 3.0) * THROW


def _point(r, deg):
    a = math.radians(deg)
    return [round(r * math.sin(a), 4), round(r * math.cos(a), 4)]


def generate_profile_points(values, mode="smooth"):
    """
    2D polygon [x, y] of the lower functional cam lobe.
    values: 18 needle positions in range 0.0 .. 3.0.
    """
    if len(values) != STEPS:
        raise ValueError(f"Profile values must contain exactly {STEPS} numbers, got {len(values)}")

    if mode == "stepped":
        pts = []
        for i in range(STEPS):
            r = _radius(values[i])
            c = i * STEP_DEG
            # dwell = true arc (a point every 2 deg), not a chord
            for k in range(int(2 * PLATEAU_HALF_DEG / 2) + 1):
                pts.append(_point(r, c - PLATEAU_HALF_DEG + 2 * k))
        return pts

    pts = []
    for deg in range(0, 360, SMOOTH_SAMPLE_DEG):
        fi = deg / STEP_DEG
        i0 = int(math.floor(fi)) % STEPS
        i1 = (i0 + 1) % STEPS
        t = fi - math.floor(fi)
        ts = (1 - math.cos(t * math.pi)) / 2
        v = _clamp_value(values[i0]) * (1 - ts) + _clamp_value(values[i1]) * ts
        pts.append(_point(BASE_RADIUS + (v / 3.0) * THROW, deg))
    return pts


def generate_icon_points(icon_kind="zigzag"):
    """Normalized 2D stroke points for the top pictogram."""
    return ICON_POINTS.get(icon_kind, ICON_POINTS["zigzag"])


def build_scad_content(cam_number, cam_name, profile_points, icon_points,
                       status="custom", mode="smooth", part="assembly",
                       include_path="_elna_measured_common.scad"):
    """OpenSCAD file linked to the shared library _elna_measured_common.scad."""
    points_str = ",\n        ".join(f"[{p[0]:.4f}, {p[1]:.4f}]" for p in profile_points)
    icon_str = ", ".join(f"[{p[0]:.3f},{p[1]:.3f}]" for p in icon_points)
    module = {
        "assembly": "elna_single_cam",
        "body": "elna_cam_body",
    }[part]

    return f"""/*
  Elna Supermatic cam {cam_number}
  Name: {cam_name}
  Status: {status}
  Surface mode: {mode}
  Part: {part}

  Generated by tools/generate_cam.py / tools/regenerate_scad.py - do not edit by hand.
  License: GPL-3.0-or-later
*/

include <{include_path}>;

profile_points = [
        {points_str}
];

icon_points = [{icon_str}];

{module}(profile_points=profile_points, icon_points=icon_points, number_text="{cam_number}");
"""


def main():
    parser = argparse.ArgumentParser(description="Elna Supermatic Cam Generator")
    parser.add_argument("--profile", help="Path to input JSON profile file")
    parser.add_argument("--cam", default="03", help="Cam number text (e.g. 03, 10, MY)")
    parser.add_argument("--name", default="Custom Cam", help="Descriptive name")
    parser.add_argument("--values", help="Comma-separated 18 float values between 0.0 and 3.0")
    parser.add_argument("--mode", choices=["smooth", "stepped"], default="smooth", help="Surface interpolation mode")
    parser.add_argument("--icon", choices=sorted(ICON_POINTS), default="zigzag", help="Pictogram kind")
    parser.add_argument("--part", choices=["assembly", "body"], default="assembly",
                        help="assembly = whole disc, body = printable body without the bottom ring")
    parser.add_argument("--include", default="_elna_measured_common.scad",
                        help="Path to _elna_measured_common.scad as seen from the output file")
    parser.add_argument("--out", help="Output .scad file path")
    parser.add_argument("--export-json", help="Export to JSON profile path")
    args = parser.parse_args()

    if args.profile:
        p_path = Path(args.profile)
        with open(p_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        cam_number = str(data.get("cam", args.cam)).zfill(2)
        cam_name = data.get("name", args.name)
        values = data.get("profile_values_nominal_0_3", [])
        mode = data.get("surface_mode", args.mode)
        icon_kind = data.get("icon_kind", args.icon)
        status = data.get("status", "custom")
    elif args.values:
        cam_number = str(args.cam)
        cam_name = args.name
        values = [float(x.strip()) for x in args.values.split(",")]
        mode = args.mode
        icon_kind = args.icon
        status = "custom"
    else:
        cam_number = "03"
        cam_name = "Zigzag reference"
        values = [0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3]
        mode = "stepped"
        icon_kind = "zigzag"
        status = "uploaded-stl/scad-reference"

    if len(values) != STEPS:
        print(f"Error: exactly {STEPS} values required, got {len(values)}", file=sys.stderr)
        sys.exit(1)

    pts = generate_profile_points(values, mode=mode)
    icon_pts = generate_icon_points(icon_kind)
    scad_code = build_scad_content(cam_number, cam_name, pts, icon_pts, status=status,
                                   mode=mode, part=args.part, include_path=args.include)

    if args.out:
        out_p = Path(args.out)
        out_p.parent.mkdir(parents=True, exist_ok=True)
        out_p.write_text(scad_code, encoding="utf-8")
        print(f"Generated SCAD: {out_p}")
    else:
        print(scad_code)

    if args.export_json:
        json_p = Path(args.export_json)
        json_p.parent.mkdir(parents=True, exist_ok=True)
        json_data = profile_json(cam_number, cam_name, "custom", values, mode, icon_kind)
        with open(json_p, "w", encoding="utf-8") as f:
            json.dump(json_data, f, indent=2, ensure_ascii=False)
        print(f"Exported JSON: {json_p}")


def profile_json(cam_number, cam_name, status, values, mode, icon_kind):
    return {
        "cam": cam_number,
        "name": cam_name,
        "status": status,
        "profile_values_nominal_0_3": values,
        "profile_radius_base_mm": BASE_RADIUS,
        "profile_throw_measured_mm": THROW,
        "surface_mode": mode,
        "icon_kind": icon_kind,
        "fixed_dimensions": {
            "overall_diameter_mm": round(2 * OVERALL_RADIUS, 3),
            "overall_radius_mm": OVERALL_RADIUS,
            "total_height_mm": TOTAL_HEIGHT,
            "body_top_height_mm": BODY_TOP_HEIGHT,
            "label_height_mm": LABEL_HEIGHT,
            "lower_cam_lobe_height_mm": LOBE_HEIGHT,
            "bottom_ring_height_mm": RING_HEIGHT,
            "upper_round_body_radius_mm": BASE_RADIUS,
            "functional_lobe_min_radius_mm": BASE_RADIUS,
            "functional_lobe_max_radius_mm": OVERALL_RADIUS,
            "functional_lobe_throw_mm": THROW,
            "center_hole_radius_mm": CENTER_HOLE_RADIUS,
            "center_counterbore_radius_mm": COUNTERBORE_RADIUS,
            "center_counterbore_height_mm": COUNTERBORE_HEIGHT,
            "center_cone_height_mm": CONE_HEIGHT,
            "transport_slot_width_mm": TRANSPORT_W,
            "transport_slot_length_mm": TRANSPORT_LEN,
            "transport_slot_depth_mm": TRANSPORT_DEPTH,
            "transport_slot_gap_from_counterbore_mm": TRANSPORT_GAP,
        },
    }


if __name__ == "__main__":
    main()
