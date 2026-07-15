# Contributing

Contributions are welcome! This project aims to provide accurate, tested 3D-printable
replacement cam discs for the Elna Supermatic sewing machine.

## What we need most

- **Top-down photos** of original Elna Supermatic cams (sharp, directly overhead, on a flat surface)
- **Measured dimensions** from physical discs (use calipers, document in `docs/`)
- **STL scans** from a 3D scanner
- **Confirmed stitch tests** with print notes (material, settings, result)
- **Corrected profile JSON files** for currently unverified `candidate` cams

---

## Verification rules

> **Do not mark a cam as `tested` without physical evidence.**

Use these status values in `docs/STATUS.md` and profile JSON files:

| Status | Meaning |
|---|---|
| `uploaded-stl/scad-reference` | Based on uploaded physical STL/SCAD reference |
| `source-profile` | Uses a known 18-position OpenSCAD profile from a trusted source |
| `photo-derived` | Profile derived from a top-down photo |
| `measured` | Profile measured from a physical disc |
| `tested` | Physically printed and tested in a machine |
| `candidate` | Based on measured body, but outer profile not yet verified |

---

## Adding a new verified cam

1. Add reference evidence to `references/cam_XX/` (photos, scans, measurements).
2. Add or update the profile JSON in `models/measured_parametric_single_v1/profiles/cam_XX_profile.json`.
3. Generate or update the `.scad` file: `models/measured_parametric_single_v1/cam_XX.scad`.
4. Update the status in `docs/STATUS.md`.
5. Update `docs/MEASURED_PARAMETRIC_INDEX.md` with your evidence.
6. Add print/test notes in `prints/cam_XX/`.
7. Open a pull request with:
   - your evidence files,
   - a description of what you measured/tested,
   - photos of the printed cam installed (if possible).

---

## Pull request checklist

- [ ] Profile JSON updated or added
- [ ] `.scad` file renders without errors in OpenSCAD
- [ ] `docs/STATUS.md` updated
- [ ] Evidence (photos, measurements) included
- [ ] Print test performed (if claiming `tested` status)

---

## Code style

- All `.scad` files should use the shared base: `_elna_measured_common.scad`
- Do **not** copy/paste body geometry into individual cam files — use the common module
- Profile points in JSON should be ordered consistently (0°–360°, 18 positions for standard cams)

---

## License

By contributing you agree that your contribution will be released under the same
[GPL-3.0-or-later](LICENSE) license as this project.
