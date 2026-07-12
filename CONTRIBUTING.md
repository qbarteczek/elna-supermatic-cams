# Contributing

Contributions are welcome, especially:

- top-down photos of original Elna Supermatic cams,
- measured dimensions,
- STL scans,
- confirmed stitch tests,
- corrected profile JSON files.

## Rules

Do not mark a cam as verified without physical evidence.

Use these status values:

- `uploaded-stl/scad-reference`
- `source-profile`
- `photo-derived`
- `measured`
- `tested`
- `candidate`

## Adding a new verified cam

1. Add reference notes in `references/`.
2. Add or update profile JSON in `models/measured_parametric_single_v1/profiles/`.
3. Generate/update `.scad`.
4. Update `docs/MEASURED_PARAMETRIC_INDEX.md`.
5. Add print/test notes in `prints/`.
