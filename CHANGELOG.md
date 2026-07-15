# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project uses [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

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
