#!/usr/bin/env python3
"""
Elna Supermatic STL analyser.

Usage:
    python3 analyse_stl.py path/to/cam.stl

Outputs:
  - Bounding box and dimensions
  - Estimated center
  - Radial profile at 18 angular positions (0–340° step 20°)
  - Min/max/throw radius
  - Transport slot position estimate
  - Z-layer breakdown (lobe height vs body height)
  - JSON-ready profile_values_nominal_0_3 array

Requires: numpy, numpy-stl
Install:  pip install numpy numpy-stl
"""

import sys
import json
import math
import numpy as np

try:
    from stl import mesh as stl_mesh
except ImportError:
    print("Missing dependency: pip install numpy-stl")
    sys.exit(1)


BASE_R  = 18.55   # mm — nominal base radius
MAX_R   = 21.82   # mm — nominal max radius
THROW_R = MAX_R - BASE_R  # 3.27 mm
N_POS   = 18


def load_stl(path):
    m = stl_mesh.Mesh.from_file(path)
    # All vertices as Nx3 array
    verts = m.vectors.reshape(-1, 3)
    return verts


def bbox(verts):
    mn = verts.min(axis=0)
    mx = verts.max(axis=0)
    return mn, mx


def estimate_center_xy(verts, z_lo, z_hi):
    """
    Use vertices in the lobe Z band to estimate disc centre.
    We take the bounding box midpoint of the outer lobe vertices.
    """
    mask = (verts[:, 2] >= z_lo) & (verts[:, 2] <= z_hi)
    lv = verts[mask]
    if len(lv) == 0:
        lv = verts
    cx = (lv[:, 0].min() + lv[:, 0].max()) / 2
    cy = (lv[:, 1].min() + lv[:, 1].max()) / 2
    return cx, cy


def radial_profile(verts, cx, cy, z_lo, z_hi, n=N_POS):
    """
    For each of n angular sectors, find the maximum radial distance
    of any vertex within the lobe Z band.
    """
    mask = (verts[:, 2] >= z_lo) & (verts[:, 2] <= z_hi)
    lv = verts[mask]
    if len(lv) == 0:
        print("  WARNING: no vertices in lobe Z band — using all vertices")
        lv = verts

    dx = lv[:, 0] - cx
    dy = lv[:, 1] - cy
    radii  = np.sqrt(dx**2 + dy**2)
    angles = np.degrees(np.arctan2(dy, dx)) % 360

    sector_w = 360 / n
    profile_r = []
    for i in range(n):
        lo = (i * sector_w - sector_w/2) % 360
        hi = (i * sector_w + sector_w/2) % 360
        if lo < hi:
            mask2 = (angles >= lo) & (angles < hi)
        else:
            mask2 = (angles >= lo) | (angles < hi)
        if mask2.sum() == 0:
            profile_r.append(BASE_R)
        else:
            profile_r.append(float(radii[mask2].max()))

    return profile_r


def r_to_value(r, base=BASE_R, throw=THROW_R):
    """Convert radius mm → profile value 0–3."""
    v = (r - base) / throw * 3
    return round(max(0.0, min(3.0, v)), 3)


def find_slot_angle(verts, cx, cy, z_lo, z_hi):
    """
    The transport slot is a rectangular cutout.
    Estimate its angular position by finding the sector with the
    minimum max-radius in the inner zone (near center hole).
    """
    mask = (verts[:, 2] >= z_lo) & (verts[:, 2] <= z_hi)
    lv = verts[mask]
    dx = lv[:, 0] - cx
    dy = lv[:, 1] - cy
    radii  = np.sqrt(dx**2 + dy**2)
    angles = np.degrees(np.arctan2(dy, dx)) % 360

    # Focus on inner annulus 8–14 mm from center
    inner = (radii >= 8) & (radii <= 14)
    if inner.sum() < 10:
        return None

    lv2 = angles[inner]
    # Histogram — slot will show as a cluster
    hist, bins = np.histogram(lv2, bins=72)  # 5° bins
    # The slot is a narrow dense cluster — find peak
    peak_bin = hist.argmax()
    slot_angle = (bins[peak_bin] + bins[peak_bin+1]) / 2
    return slot_angle


def z_bands(verts):
    z_min = verts[:, 2].min()
    z_max = verts[:, 2].max()
    return z_min, z_max


def analyse(path):
    print(f"\n{'='*60}")
    print(f"  Elna STL Analyser")
    print(f"  File: {path}")
    print(f"{'='*60}\n")

    verts = load_stl(path)
    print(f"Vertices loaded: {len(verts):,}")

    mn, mx = bbox(verts)
    ext = mx - mn
    print(f"\n── Bounding box ──")
    print(f"  Min:     {mn}")
    print(f"  Max:     {mx}")
    print(f"  Extents: {ext} mm")
    print(f"  Nominal overall diameter: {ext[0]:.3f} × {ext[1]:.3f} mm")

    z_min, z_max = z_bands(verts)
    total_h = z_max - z_min
    print(f"\n── Z range ──")
    print(f"  Z min: {z_min:.3f} mm")
    print(f"  Z max: {z_max:.3f} mm")
    print(f"  Total height: {total_h:.3f} mm  (expected ~7.308 mm)")

    # Lobe zone: lower portion of the disc
    # Typically the lobe is the bottom 4.5 mm; upper body is rounds
    lobe_z_lo = z_min
    lobe_z_hi = z_min + total_h * 0.65  # adjust based on what we find

    cx, cy = estimate_center_xy(verts, lobe_z_lo, lobe_z_hi)
    print(f"\n── Estimated centre (XY) ──")
    print(f"  cx = {cx:.3f} mm")
    print(f"  cy = {cy:.3f} mm")
    print(f"  (from file origin, not normalised)")

    profile_r = radial_profile(verts, cx, cy, lobe_z_lo, lobe_z_hi)
    profile_v = [r_to_value(r) for r in profile_r]

    print(f"\n── Radial profile (18 positions, 0°–340°) ──")
    print(f"  {'Pos':>4}  {'Angle':>6}  {'Radius mm':>10}  {'Value 0-3':>10}")
    for i, (r, v) in enumerate(zip(profile_r, profile_v)):
        print(f"  {i:>4}  {i*20:>5}°  {r:>10.3f}  {v:>10.3f}")

    r_min = min(profile_r)
    r_max = max(profile_r)
    throw = r_max - r_min
    print(f"\n── Profile summary ──")
    print(f"  Min radius:  {r_min:.3f} mm  (expected ≥ {BASE_R:.2f})")
    print(f"  Max radius:  {r_max:.3f} mm  (expected ≤ {MAX_R:.2f})")
    print(f"  Throw:       {throw:.3f} mm  (expected ≈ {THROW_R:.2f})")

    slot_angle = find_slot_angle(verts, cx, cy, lobe_z_lo, lobe_z_hi)
    print(f"\n── Transport slot ──")
    if slot_angle is not None:
        print(f"  Estimated slot angle: {slot_angle:.1f}°")
        print(f"  (current model assumes slot at +Y axis ≈ 90°)")
        slot_offset = (slot_angle - 90) % 360
        print(f"  Angular offset from reference: {slot_offset:.1f}°")
    else:
        print("  Could not estimate slot angle (insufficient vertices)")

    print(f"\n── JSON profile_values_nominal_0_3 ──")
    print(json.dumps(profile_v, indent=2))

    # Write result file
    result = {
        "source_file": path,
        "bounding_box_mm": {
            "min": mn.tolist(), "max": mx.tolist(), "extents": ext.tolist()
        },
        "total_height_mm": round(float(total_h), 4),
        "centre_xy_mm": [round(float(cx), 3), round(float(cy), 3)],
        "lobe_z_band_mm": [round(float(lobe_z_lo), 3), round(float(lobe_z_hi), 3)],
        "profile_radii_mm": [round(r, 4) for r in profile_r],
        "profile_values_nominal_0_3": profile_v,
        "r_min_mm": round(float(r_min), 3),
        "r_max_mm": round(float(r_max), 3),
        "throw_mm": round(float(throw), 3),
        "slot_angle_deg": round(float(slot_angle), 1) if slot_angle else None,
    }
    out_path = path.replace('.stl', '_analysis.json').replace('.STL', '_analysis.json')
    with open(out_path, 'w') as f:
        json.dump(result, f, indent=2)
    print(f"\n✓ Analysis written to: {out_path}")
    return result


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python3 analyse_stl.py path/to/cam.stl")
        sys.exit(1)
    analyse(sys.argv[1])
