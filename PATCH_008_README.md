# Patch 008 — measured parametric base

This patch fixes the earlier mistake: it does not try to edit the frozen mesh SCAD.

Instead it builds a clean parametric OpenSCAD base using the dimensions read from the uploaded STL/SCAD files.

## Rule

Preserve:
- measured outer size,
- total height,
- upper round body,
- central hole,
- lower counterbore/cone,
- transport slot,
- top style layout.

Change only:
- lower functional cam edge,
- number,
- stitch pictogram.

## Folder

```text
models/measured_parametric_single_v1/
```

## Open first

```text
models/measured_parametric_single_v1/cam_03.scad
```

Then check source-profile cams:

```text
models/measured_parametric_single_v1/cam_13.scad
models/measured_parametric_single_v1/cam_16.scad
models/measured_parametric_single_v1/cam_20.scad
models/measured_parametric_single_v1/cam_33.scad
```

## Included cams

01–34.

## Important

Only cam 03 and source-profile cams 13, 16, 20, 33 should be treated as grounded.
The rest are candidate profiles until verified from real photos or STL scans.
