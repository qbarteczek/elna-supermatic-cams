# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project uses [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Fixed (2026-10-23, geometry v3)
- Markings and pictograms floated up to 1.4 mm above the domed top (26 loose shells per STL).
  They are now trimmed to the real top surface and every STL is a single watertight body.
- Top face is flat again like the reference STL (total height 7.308 mm instead of 8.8 mm);
  the dome is optional (`dome_crown`, Customizer `DOME_CROWN`).
- Body + universal ring now add up to the assembly (the old body already contained the
  bottom 1.2 mm). The cam lobe starts at 1.2 mm, like the reference disc.
- Stepped profiles were half a step (10 deg) out of phase with the transport slot; steps are
  now centred on the slot direction as on the reference disc, and dwells are true arcs.
- Cam 33 profile had 16 values instead of 18.
- Browser STL export had no transport slot; the in-browser mesh is now watertight, has the
  slot and uses the same profile math as OpenSCAD/Python.
- Preview showed or downloaded the catalogue STL even after the profile, mode or number was changed.
- Generated `.scad` included two library paths and always used the zigzag pictogram.
- OpenSCAD Customizer had its own outdated presets and geometry; it now uses the shared library
  and can generate body, ring or assembly.

### Changed
- One source of truth: profiles JSON + `tools/generate_cam.py`; `tools/regenerate_scad.py`
  writes the SCAD files, Customizer presets, library pictograms and the data in `index.html`.
- Removed the stale `tools/build_index_html.py` (running it would have overwritten `index.html`).
- `tools/render_all_stls.sh` always re-renders, writes binary STL (52 MB instead of ~195 MB)
  and uses the Manifold backend when available.
- Layout of the top markings follows the reference disc (SWISS MADE arc with slot marker,
  18 step notches); 11 pictograms available in the editor; step bars work with touch.

### Planned
- Physical test results for candidate cams
- Top-down reference photos for unverified cams
- Corrected outer profiles based on physical measurements

---

## [0.1.0] — 2026-07-15

### Added
- Measured parametric Elna Supermatic single cam base (`_elna_measured_common.scad`)
- Generated SCAD files for cams 01–34 in `models/measured_parametric_single_v1/`
- Profile JSON files for all 34 cams in `profiles/`
- Dimension documentation from uploaded STL/SCAD reference files (`docs/DIMENSIONS_FROM_UPLOADED_FILES.md`)
- Verification status system: `uploaded-stl/scad-reference`, `source-profile`, `candidate`
- Grounded models: cam 03 (STL/SCAD reference), cams 13, 16, 20, 33 (known 18-position profiles)
- Validation script for profile JSON files (`tools/`)
- Measurement protocol documentation (`docs/MEASUREMENT_PROTOCOL.md`)
- Status tracking document (`docs/STATUS.md`)
- `.gitignore` to prevent accidental commits of generated STL files

### Design decisions
- Body geometry is fixed and shared via `_elna_measured_common.scad`
- Only the functional cam edge, cam number, and stitch pictogram change per cam
- This approach replaced an earlier failed attempt to edit frozen mesh SCAD files (Patch 008)

[Unreleased]: https://github.com/qbarteczek/elna-supermatic-cams/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/qbarteczek/elna-supermatic-cams/releases/tag/v0.1.0
