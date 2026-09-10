#!/usr/bin/env python3
"""
Elna Supermatic Cam Generator CLI
Generates OpenSCAD models and JSON profile files for Elna Supermatic single cams
using measured parametric dimensions.

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

CENTER_HOLE_RADIUS = 8.250
COUNTERBORE_RADIUS = 9.500
COUNTERBORE_HEIGHT = 1.500
CONE_HEIGHT = 1.500

TRANSPORT_W = 3.000
TRANSPORT_LEN = 4.100
TRANSPORT_DEPTH = 5.500
TRANSPORT_GAP = 1.000


def catmull_rom_cyclic(points, num_samples=180):
    """Interpolate cyclic 1D points with Catmull-Rom spline."""
    n = len(points)
    result = []
    for i in range(num_samples):
        t_global = (i / num_samples) * n
        idx1 = int(t_global) % n
        idx0 = (idx1 - 1) % n
        idx2 = (idx1 + 1) % n
        idx3 = (idx1 + 2) % n
        t = t_global - int(t_global)

        p0 = points[idx0]
        p1 = points[idx1]
        p2 = points[idx2]
        p3 = points[idx3]

        # Catmull-Rom formula
        val = 0.5 * (
            (2 * p1) +
            (-p0 + p2) * t +
            (2 * p0 - 5 * p1 + 4 * p2 - p3) * (t ** 2) +
            (-p0 + 3 * p1 - 3 * p2 + p3) * (t ** 3)
        )
        result.append(val)
    return result


def generate_profile_points(values, mode="smooth"):
    """
    Generate 2D polygon vertices [x, y] for the lower functional cam lobe.
    values: 18 values in range [0.0, 3.0]
    """
    if len(values) != 18:
        raise ValueError("Profile values must contain exactly 18 numbers")

    if mode == "stepped":
        # 36 points: 2 points per 20-deg sector to form flat cam lobes
        pts = []
        for i in range(18):
            v = max(0.0, min(3.0, float(values[i])))
            r = BASE_RADIUS + (v / 3.0) * THROW
            a_center = i * 20.0
            a1 = math.radians(a_center - 4.5)
            a2 = math.radians(a_center + 4.5)
            pts.append([round(r * math.sin(a1), 4), round(r * math.cos(a1), 4)])
            pts.append([round(r * math.sin(a2), 4), round(r * math.cos(a2), 4)])
        return pts
    else:
        # Smooth interpolation
        interpolated = catmull_rom_cyclic(values, num_samples=180)
        pts = []
        for i, v in enumerate(interpolated):
            v_clamped = max(0.0, min(3.0, float(v)))
            r = BASE_RADIUS + (v_clamped / 3.0) * THROW
            a = math.radians(i * (360.0 / len(interpolated)))
            pts.append([round(r * math.sin(a), 4), round(r * math.cos(a), 4)])
        return pts


def generate_icon_points(icon_kind="zigzag"):
    """Generate normalized 2D stroke points for top pictogram."""
    if icon_kind == "step":
        return [
            [-1.000, 0.180], [-0.820, 0.180], [-0.820, 0.360], [-0.640, 0.360],
            [-0.640, 0.560], [-0.460, 0.560], [-0.460, 0.740], [-0.280, 0.740],
            [-0.280, 0.560], [-0.100, 0.560], [-0.100, 0.360], [0.080, 0.360],
            [0.080, 0.180], [0.260, 0.180], [0.260, 0.360], [0.440, 0.360],
            [0.440, 0.560], [0.620, 0.560], [0.620, 0.740], [0.800, 0.740],
            [1.000, 0.740]
        ]
    elif icon_kind == "wave":
        pts = []
        for i in range(25):
            t = -1.0 + (i / 24.0) * 2.0
            y = 0.5 + 0.45 * math.sin(t * math.pi * 2.5)
            pts.append([round(t, 3), round(y, 3)])
        return pts
    elif icon_kind == "blind":
        return [
            [-1.0, 0.2], [-0.6, 0.2], [-0.4, 0.9], [-0.2, 0.2],
            [0.2, 0.2], [0.4, 0.9], [0.6, 0.2], [1.0, 0.2]
        ]
    else:  # zigzag
        return [
            [-1.000, 0.040], [-0.889, 0.960], [-0.778, 0.040], [-0.667, 0.960],
            [-0.556, 0.040], [-0.444, 0.960], [-0.333, 0.040], [-0.222, 0.960],
            [-0.111, 0.040], [0.000, 0.960], [0.111, 0.040], [0.222, 0.960],
            [0.333, 0.040], [0.444, 0.960], [0.556, 0.040], [0.667, 0.960],
            [0.778, 0.040], [0.889, 0.960], [1.000, 0.040]
        ]


def build_scad_content(cam_number, cam_name, profile_points, icon_points):
    """Build self-contained or library-linked OpenSCAD code."""
    points_str = ",\n        ".join(f"[{p[0]:.4f}, {p[1]:.4f}]" for p in profile_points)
    icon_str = ", ".join(f"[{p[0]:.3f},{p[1]:.3f}]" for p in icon_points)

    return f"""/*
  Elna Supermatic Cam {cam_number}
  Name: {cam_name}
  Generated via Elna Supermatic Cam Generator
  License: GPL-3.0-or-later
*/

// Include library base if present
include <../measured_parametric_single_v1/_elna_measured_common.scad>;
include <_elna_measured_common.scad>;

profile_points = [
        {points_str}
];

icon_points = [{icon_str}];

elna_single_cam(profile_points=profile_points, icon_points=icon_points, number_text="{cam_number}");
"""


def main():
    parser = argparse.ArgumentParser(description="Elna Supermatic Cam Generator")
    parser.add_argument("--profile", help="Path to input JSON profile file")
    parser.add_argument("--cam", default="03", help="Cam number text (e.g. 03, 10, MY)")
    parser.add_argument("--name", default="Custom Cam", help="Descriptive name")
    parser.add_argument("--values", help="Comma-separated 18 float values between 0.0 and 3.0")
    parser.add_argument("--mode", choices=["smooth", "stepped"], default="smooth", help="Surface interpolation mode")
    parser.add_argument("--icon", choices=["zigzag", "step", "wave", "blind"], default="zigzag", help="Pictogram kind")
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
    elif args.values:
        cam_number = str(args.cam)
        cam_name = args.name
        values = [float(x.strip()) for x in args.values.split(",")]
        mode = args.mode
        icon_kind = args.icon
    else:
        # Default cam 03
        cam_number = "03"
        cam_name = "Zigzag reference"
        values = [0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3]
        mode = "stepped"
        icon_kind = "zigzag"

    if len(values) != 18:
        print(f"Error: exactly 18 values required, got {len(values)}", file=sys.stderr)
        sys.exit(1)

    pts = generate_profile_points(values, mode=mode)
    icon_pts = generate_icon_points(icon_kind)
    scad_code = build_scad_content(cam_number, cam_name, pts, icon_pts)

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
        json_data = {
            "cam": cam_number,
            "name": cam_name,
            "status": "custom",
            "profile_values_nominal_0_3": values,
            "profile_radius_base_mm": BASE_RADIUS,
            "profile_throw_measured_mm": THROW,
            "surface_mode": mode,
            "icon_kind": icon_kind,
            "fixed_dimensions": {
                "overall_diameter_mm": 43.64,
                "overall_radius_mm": 21.82,
                "total_height_mm": TOTAL_HEIGHT,
                "body_top_height_mm": BODY_TOP_HEIGHT,
                "label_height_mm": LABEL_HEIGHT,
                "lower_cam_lobe_height_mm": LOBE_HEIGHT,
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
                "transport_slot_gap_from_counterbore_mm": TRANSPORT_GAP
            }
        }
        with open(json_p, "w", encoding="utf-8") as f:
            json.dump(json_data, f, indent=2, ensure_ascii=False)
        print(f"Exported JSON: {json_p}")


if __name__ == "__main__":
    main()
