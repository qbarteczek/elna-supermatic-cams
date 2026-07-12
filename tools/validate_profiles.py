#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROFILE_DIR = ROOT / "models" / "measured_parametric_single_v1" / "profiles"

def main() -> None:
    errors = 0
    profiles = sorted(PROFILE_DIR.glob("cam_*_profile.json"))

    if not profiles:
        print("No profile JSON files found.")
        raise SystemExit(1)

    for path in profiles:
        data = json.loads(path.read_text(encoding="utf-8"))
        cam = data.get("cam")
        values = data.get("profile_values_nominal_0_3")
        status = data.get("status")

        ok = True
        if not isinstance(cam, str):
            print(f"{path}: missing/string cam")
            ok = False
        if not isinstance(values, list) or len(values) != 18:
            print(f"{path}: profile_values_nominal_0_3 must contain exactly 18 values")
            ok = False
        elif any((not isinstance(v, (int, float))) or v < 0 or v > 3 for v in values):
            print(f"{path}: profile values must be numeric and in range 0..3")
            ok = False
        if not status:
            print(f"{path}: missing status")
            ok = False

        if ok:
            print(f"OK {path.name}: cam {cam}, status={status}")
        else:
            errors += 1

    if errors:
        raise SystemExit(errors)

if __name__ == "__main__":
    main()
