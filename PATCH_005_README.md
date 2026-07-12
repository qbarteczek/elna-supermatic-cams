# Patch 005 — visible raised labels

This patch fixes the issue where cam number and stitch preview were not visible.

## What changed

Labels are now raised geometry:

- raised 7-segment cam number,
- raised stitch preview icon,
- no dependency on OpenSCAD font rendering for the number,
- STL references copied into `models/stl_reference/`,
- STL size analysis added in `docs/STL_REFERENCE_ANALYSIS.md`.

## Added folder

```text
models/labeled_single_cams_v1/
```

## Start here

Open:

```text
models/labeled_single_cams_v1/cam_03.scad
```

Then check:

```text
models/labeled_single_cams_v1/cam_13.scad
models/labeled_single_cams_v1/cam_16.scad
models/labeled_single_cams_v1/cam_20.scad
models/labeled_single_cams_v1/cam_33.scad
```

## Included cam files

01, 02, 03, 04, 05, 06, 10, 11, 12, 13, 16, 17, 18, 20, 33

## Important

Models marked `source-profile` are based on known source profiles.
Models marked `candidate` still require verification from top-down photos, original cams, or STL scans.
