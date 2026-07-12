# Visible labels

Patch 005 changes the marking method:

- no engraved text,
- no OpenSCAD font dependency for the cam number,
- raised 7-segment number made from rectangular geometry,
- raised stitch preview made from rectangular geometry.

This should be visible in OpenSCAD render and on a physical print.

## Why raised?

Engraving on a small 3D-printed cam can disappear after slicing, especially with large layer height or if the cut is shallow.
Raised geometry is much more reliable.

## First test

Open:

```text
models/labeled_single_cams_v1/cam_03.scad
```

You should see:
- raised number `03`,
- raised zigzag icon at the top.

If the icon is too high or collides mechanically, reduce `label_height` in the SCAD file.
