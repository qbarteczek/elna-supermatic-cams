#!/usr/bin/env python3
"""
Independent check of the printable STL files in stls/ (does not use the generator code,
only the profile JSON and the nominal dimensions).

For every cam: cam_XX.stl (whole disc) and cam_XX_body.stl (without the bottom ring),
plus stls/universal_ring.stl:
  - one watertight, consistently wound body (no loose shells, e.g. markings floating above the top),
  - outer size: diameter from the profile (max 43.64), total height 7.308; the body STL is exported
    lowered by the ring height (z 0 .. 6.108, prints flat); ring: 0 .. 1.2,
  - centre hole r 8.25, counterbore r 9.5 (bottom 1.5 mm), transport slot on +Y
    (y 10.5 .. 14.6, x +-1.5, depth 5.5 from the bottom),
  - body + ring volume = whole disc volume,
  - cam lobe radius at the 18 step centres (angle 0 = slot direction +Y, clockwise from the top)
    matches the profile values: r = 18.55 + v/3 * 3.27.

    python tools/verify_stls.py            # all cams
    python tools/verify_stls.py 03 12      # selected cams
Exit code 1 when anything fails.
"""
import json
import math
import sys
from pathlib import Path

import numpy as np
import trimesh

ROOT = Path(__file__).resolve().parent.parent
STLS = ROOT / "stls"
PROFILES = ROOT / "models" / "measured_parametric_single_v1" / "profiles"

R_OUT, H_TOTAL, H_BODY_TOP, RING_H = 21.82, 7.308, 6.999, 1.2
R_BASE, THROW = 18.55, 3.27
R_HOLE, R_CB, H_CB = 8.25, 9.5, 1.5
SLOT_Y0, SLOT_Y1, SLOT_HALF_W, SLOT_DEPTH = 10.5, 14.6, 1.5, 5.5
TOL_DIM = 0.05        # mm, sizes
TOL_PROFILE = 0.08    # mm, lobe radius (polygon facets of the arcs)
LOBE_Z = 2.8          # section height inside the lobe (lobe: 1.2 .. 4.499)


def hits(mesh, origin, direction):
    """Distances from origin along direction to every surface crossing, sorted."""
    locs, _, _ = mesh.ray.intersects_location([origin], [direction], multiple_hits=True)
    if len(locs) == 0:
        return []
    d = np.linalg.norm(locs - np.asarray(origin), axis=1)
    d = np.unique(np.round(d, 3))
    return list(d)


def ray_dir(deg):
    a = math.radians(deg)
    return [math.sin(a), math.cos(a), 0.0]


def check_solid(mesh, name, problems):
    bodies = mesh.split(only_watertight=False)
    if len(bodies) != 1:
        problems.append(f"{name}: {len(bodies)} separate bodies (expected 1)")
    if not mesh.is_watertight:
        problems.append(f"{name}: not watertight")
    if not mesh.is_winding_consistent:
        problems.append(f"{name}: inconsistent face winding")
    if mesh.volume <= 0:
        problems.append(f"{name}: volume {mesh.volume:.1f} <= 0 (inverted normals?)")


def check_bounds(mesh, name, z0, z1, r, problems):
    (xmin, ymin, zmin), (xmax, ymax, zmax) = mesh.bounds
    d = 2 * float(np.max(np.hypot(mesh.vertices[:, 0], mesh.vertices[:, 1])))   # largest radius, any direction
    if abs(zmin - z0) > TOL_DIM:
        problems.append(f"{name}: bottom at z={zmin:.3f}, expected {z0}")
    if abs(zmax - z1) > TOL_DIM:
        problems.append(f"{name}: top at z={zmax:.3f}, expected {z1}")
    if abs(d - 2 * r) > 2 * TOL_PROFILE:
        problems.append(f"{name}: diameter {d:.3f}, expected {2 * r:.2f}")


def check_hole_and_slot(mesh, name, z_slot, z_cb, problems, dz=0.0):
    """dz: the body STL is exported lowered by the ring height (prints flat), z values are given unlowered."""
    z_slot -= dz
    z_cb = None if z_cb is None else z_cb - dz
    # centre hole: first wall away from the slot (180 deg = -Y)
    h = hits(mesh, [0, 0, z_slot], ray_dir(180))
    if not h or abs(h[0] - R_HOLE) > TOL_DIM:
        problems.append(f"{name}: centre hole wall at {h[0] if h else None}, expected r {R_HOLE}")
    if z_cb is not None:
        h = hits(mesh, [0, 0, z_cb], ray_dir(180))
        if not h or abs(h[0] - R_CB) > TOL_DIM:
            problems.append(f"{name}: counterbore wall at {h[0] if h else None}, expected r {R_CB}")
    # transport slot along +Y: hole wall, slot start, slot end, outside
    h = hits(mesh, [0, 0, z_slot], ray_dir(0))
    want = [R_HOLE, SLOT_Y0, SLOT_Y1]
    if len(h) < 3 or any(abs(a - b) > TOL_DIM for a, b in zip(h[:3], want)):
        problems.append(f"{name}: slot along +Y crossings {h[:4]}, expected {want} ...")
    # slot width: at y in the middle of the slot, rays along +-X from the slot centre
    yc = (SLOT_Y0 + SLOT_Y1) / 2
    for sx in (1, -1):
        h = hits(mesh, [0, yc, z_slot], [sx, 0, 0])
        if not h or abs(h[0] - SLOT_HALF_W) > TOL_DIM:
            problems.append(f"{name}: slot half width {h[0] if h else None}, expected {SLOT_HALF_W}")
            break
    # slot depth: from inside the slot, upwards
    z0 = 0.05
    h = hits(mesh, [0, yc, z0], [0, 0, 1])
    top = round(h[0] + z0 + dz, 3) if h else None
    if top is None or abs(top - SLOT_DEPTH) > TOL_DIM:
        problems.append(f"{name}: slot roof at z={top} (assembly), expected {SLOT_DEPTH}")


def check_profile(mesh, name, values, problems, dz=0.0):
    bad = []
    for i, v in enumerate(values):
        want = R_BASE + max(0.0, min(3.0, float(v))) / 3.0 * THROW
        h = hits(mesh, [0, 0, LOBE_Z - dz], ray_dir(20 * i))
        got = h[-1] if h else None
        if got is None or abs(got - want) > TOL_PROFILE:
            bad.append(f"step {i + 1}: r={got if got is None else round(got, 3)} want {want:.3f}")
    if bad:
        problems.append(f"{name}: lobe profile off at {len(bad)}/18 steps: " + "; ".join(bad[:4])
                        + (" ..." if len(bad) > 4 else ""))


def main():
    only = set(a.zfill(2) for a in sys.argv[1:])
    problems, checked = [], 0
    ring = None
    rp = STLS / "universal_ring.stl"
    if rp.exists():
        ring = trimesh.load(rp, force="mesh")
        check_solid(ring, rp.name, problems)
        check_bounds(ring, rp.name, 0.0, RING_H, R_BASE, problems)
        # ring: inner wall = counterbore (r 9.5), slot through the whole ring
        h = hits(ring, [0, 0, RING_H / 2], ray_dir(180))
        if not h or abs(h[0] - R_CB) > TOL_DIM:
            problems.append(f"{rp.name}: inner wall at {h[0] if h else None}, expected r {R_CB}")
        h = hits(ring, [0, 0, RING_H / 2], ray_dir(0))
        want = [R_CB, SLOT_Y0, SLOT_Y1]
        if len(h) < 3 or any(abs(x - y) > TOL_DIM for x, y in zip(h[:3], want)):
            problems.append(f"{rp.name}: slot crossings {h[:4]}, expected {want} ...")
    else:
        problems.append("universal_ring.stl missing")

    for prof in sorted(PROFILES.glob("cam_*_profile.json")):
        num = prof.name[4:6]
        if only and num not in only:
            continue
        data = json.loads(prof.read_text(encoding="utf-8"))
        values = data.get("profile_values_nominal_0_3") or []
        if len(values) != 18:
            problems.append(f"cam {num}: profile has {len(values)} values (expected 18)")
            continue
        whole, body = STLS / f"cam_{num}.stl", STLS / f"cam_{num}_body.stl"
        missing = [p.name for p in (whole, body) if not p.exists()]
        if missing:
            problems += [f"{m} missing" for m in missing]
            continue
        mw = trimesh.load(whole, force="mesh")
        mb = trimesh.load(body, force="mesh")
        r_max = R_BASE + max(0.0, min(3.0, max(map(float, values)))) / 3.0 * THROW
        check_solid(mw, whole.name, problems)
        check_solid(mb, body.name, problems)
        check_bounds(mw, whole.name, 0.0, H_TOTAL, r_max, problems)
        check_bounds(mb, body.name, 0.0, H_TOTAL - RING_H, r_max, problems)   # body prints flat: lowered by the ring
        check_hole_and_slot(mw, whole.name, 3.5, 0.7, problems)
        check_hole_and_slot(mb, body.name, 3.5, None, problems, dz=RING_H)
        check_profile(mw, whole.name, values, problems)
        check_profile(mb, body.name, values, problems, dz=RING_H)
        if ring is not None and mw.volume > 0:
            diff = (mb.volume + ring.volume - mw.volume) / mw.volume
            if abs(diff) > 0.005:
                problems.append(f"cam {num}: body + ring volume differs from the whole disc by {diff * 100:+.2f} %")
        checked += 1
        print(f"cam {num}: checked", flush=True)

    print(f"\n{checked} cams checked, {len(problems)} problems")
    for p in problems:
        print(" -", p)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
