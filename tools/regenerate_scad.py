#!/usr/bin/env python3
"""
Regenerates everything that is derived from the cam profiles.

Source of truth:
  models/measured_parametric_single_v1/profiles/cam_XX_profile.json  (values, mode, icon, name, status)
  tools/generate_cam.py                                              (profile math, pictograms)

Writes:
  models/measured_parametric_single_v1/cam_XX.scad       (assembly)
  models/measured_parametric_single_v1/cam_XX_body.scad  (printable body)
  models/measured_parametric_single_v1/profiles/*.json   (normalised, fixed dimensions refreshed)
  models/measured_parametric_single_v1/_elna_measured_common.scad  (block <generated:icons>)
  tools/openscad/elna_cam_generator.scad                 (block <generated:presets>)
  tools/all_profiles_dump.json
  index.html                                             (block <generated:presets>)

Then render the STL files: tools/render_all_stls.sh

Run from the repository root:  python tools/regenerate_scad.py
"""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import generate_cam as gc  # noqa: E402

SCAD_DIR = ROOT / "models" / "measured_parametric_single_v1"
PROFILES_DIR = SCAD_DIR / "profiles"
COMMON_SCAD = SCAD_DIR / "_elna_measured_common.scad"
CUSTOMIZER_SCAD = ROOT / "tools" / "openscad" / "elna_cam_generator.scad"
DUMP_JSON = ROOT / "tools" / "all_profiles_dump.json"
HTML_FILES = [ROOT / "index.html"]


def replace_block(text, tag, new_body, path):
    """Replace the lines between '<generated:TAG>' and '</generated:TAG>' markers."""
    pattern = re.compile(r"(<generated:%s>[^\n]*\n)(.*?)(\n[^\n]*</generated:%s>)" % (tag, tag), re.S)
    if not pattern.search(text):
        raise SystemExit(f"Marker <generated:{tag}> not found in {path}")
    return pattern.sub(lambda m: m.group(1) + new_body + m.group(3), text, count=1)


def scad_list(points, ndigits=3):
    return "[" + ",".join(f"[{round(x, ndigits)},{round(y, ndigits)}]" for x, y in points) + "]"


def load_profiles():
    profiles = []
    for path in sorted(PROFILES_DIR.glob("cam_*_profile.json")):
        data = json.loads(path.read_text(encoding="utf-8"))
        values = data["profile_values_nominal_0_3"]
        if len(values) != gc.STEPS:
            raise SystemExit(f"{path.name}: expected {gc.STEPS} values, got {len(values)}")
        if data.get("surface_mode") not in ("stepped", "smooth"):
            raise SystemExit(f"{path.name}: unknown surface_mode {data.get('surface_mode')!r}")
        if data.get("icon_kind") not in gc.ICON_POINTS:
            raise SystemExit(f"{path.name}: unknown icon_kind {data.get('icon_kind')!r}")
        profiles.append((path, data))
    return profiles


def write_cam_scads(profiles):
    for _, d in profiles:
        cam = d["cam"]
        pts = gc.generate_profile_points(d["profile_values_nominal_0_3"], d["surface_mode"])
        icon = gc.generate_icon_points(d["icon_kind"])
        for part, suffix in (("assembly", ""), ("body", "_body")):
            code = gc.build_scad_content(cam, d["name"], pts, icon, status=d.get("status", "candidate"),
                                         mode=d["surface_mode"], part=part)
            (SCAD_DIR / f"cam_{cam}{suffix}.scad").write_text(code, encoding="utf-8")


def write_profile_jsons(profiles):
    for path, d in profiles:
        fresh = gc.profile_json(d["cam"], d["name"], d.get("status", "candidate"),
                                d["profile_values_nominal_0_3"], d["surface_mode"], d["icon_kind"])
        path.write_text(json.dumps(fresh, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def presets_list(profiles):
    return [{
        "cam": d["cam"],
        "name": d["name"],
        "status": d.get("status", "candidate"),
        "values": d["profile_values_nominal_0_3"],
        "mode": d["surface_mode"],
        "icon": d["icon_kind"],
    } for _, d in profiles]


def write_common_icons():
    lines = ["function elna_icon_points(kind) ="]
    for kind, pts in gc.ICON_POINTS.items():
        lines.append(f'    (kind == "{kind}") ? {scad_list(pts)} :')
    lines.append(f"    {scad_list(gc.ICON_POINTS['zigzag'])};")
    text = COMMON_SCAD.read_text(encoding="utf-8")
    COMMON_SCAD.write_text(replace_block(text, "icons", "\n".join(lines), COMMON_SCAD), encoding="utf-8")


def write_customizer(presets):
    def table(name, key, fmt, default):
        out = [f"function {name}(p) ="]
        for p in presets:
            out.append(f'    (p == "{p["cam"]}") ? {fmt(p[key])} :')
        out.append(f"    {default};")
        return "\n".join(out)

    body = "\n".join([
        table("preset_values", "values", lambda v: json.dumps(v).replace(" ", ""), "undef"),
        table("preset_mode", "mode", lambda v: f'"{v}"', '"stepped"'),
        table("preset_icon", "icon", lambda v: f'"{v}"', '"zigzag"'),
    ])
    text = CUSTOMIZER_SCAD.read_text(encoding="utf-8")
    CUSTOMIZER_SCAD.write_text(replace_block(text, "presets", body, CUSTOMIZER_SCAD), encoding="utf-8")


def write_html(presets):
    js = "\n".join([
        "    const CAM_PRESETS = " + json.dumps(presets, ensure_ascii=False) + ";",
        "    const ICON_POINTS = " + json.dumps(gc.ICON_POINTS) + ";",
        "    const ICON_LABELS = " + json.dumps(gc.ICON_LABELS_PL, ensure_ascii=False) + ";",
    ])
    for path in HTML_FILES:
        text = path.read_text(encoding="utf-8")
        path.write_text(replace_block(text, "presets", js, path), encoding="utf-8", newline="\n")


def main():
    profiles = load_profiles()
    presets = presets_list(profiles)
    write_profile_jsons(profiles)
    write_cam_scads(profiles)
    write_common_icons()
    write_customizer(presets)
    DUMP_JSON.write_text(json.dumps(presets, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    write_html(presets)
    print(f"Regenerated {len(presets)} cams: SCAD (assembly + body), profiles, customizer, "
          f"library icons, {DUMP_JSON.name}, index.html.")
    print("Next: render STL files with tools/render_all_stls.sh")


if __name__ == "__main__":
    main()
