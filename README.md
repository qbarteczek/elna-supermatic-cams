# Elna Supermatic Cam Discs — measured parametric models

OpenSCAD models for Elna Supermatic single cam discs.

The current model set is based on a measured parametric base derived from uploaded reference STL/SCAD files for cam **03 / zigzag**.  
The goal is to preserve the original Elna-style body, holes, height and top layout while changing only:

1. the lower functional cam edge,
2. the cam number,
3. the stitch pictogram.

## Current status

The most important folder is:

```text
models/measured_parametric_single_v1/
```

It contains generated `.scad` files for single cams:

```text
01–34
```

### Grounded / more reliable models

These models have the strongest basis:

| Cam | Basis |
|---:|---|
| 03 | uploaded STL/SCAD reference cam |
| 13 | known 18-position OpenSCAD profile |
| 16 | known 18-position OpenSCAD profile |
| 20 | known 18-position OpenSCAD profile |
| 33 | known 18-position OpenSCAD profile |

Other cams are included as **candidate profiles**. They use the same measured base, but their outer functional edge still needs verification from real top-down photos, scans or original discs.

## Open first

Open this file in OpenSCAD:

```text
models/measured_parametric_single_v1/cam_03.scad
```

Then compare with:

```text
models/measured_parametric_single_v1/cam_13.scad
models/measured_parametric_single_v1/cam_16.scad
models/measured_parametric_single_v1/cam_20.scad
models/measured_parametric_single_v1/cam_33.scad
```

## Dimensions

Main dimensions are documented in:

```text
docs/DIMENSIONS_FROM_UPLOADED_FILES.md
```

Key values:

| Parameter | Value |
|---|---:|
| Overall diameter | ~43.64 mm |
| Overall height | 7.308 mm |
| Lower cam lobe height | 4.499 mm |
| Upper round body radius | ~18.55 mm |
| Max functional lobe radius | ~21.82 mm |
| Center hole radius | 8.25 mm |

## Design rule

The body is fixed. Only the functional edge, number and stitch icon should change between single cams.

This avoids the earlier mistake of rebuilding the entire cam body and losing the Elna geometry.

## File structure

```text
docs/
  DIMENSIONS_FROM_UPLOADED_FILES.md
  MEASURED_PARAMETRIC_INDEX.md

models/
  measured_parametric_single_v1/
    _elna_measured_common.scad
    cam_01.scad
    ...
    cam_34.scad
    profiles/
      cam_01_profile.json
      ...
      cam_34_profile.json

references/
photos/
prints/
tools/
```

## Rendering

Open any `.scad` file in OpenSCAD and render/export STL.

Example:

```text
models/measured_parametric_single_v1/cam_03.scad
```

## Safety / testing

These are mechanical parts for a sewing machine. Before using any printed cam:

1. inspect dimensions,
2. test fit without force,
3. rotate the machine by hand,
4. test slowly,
5. only then try powered stitching.

Do not mark a cam as verified until it has been physically tested.

## License

GPL-3.0-or-later.

This repo builds on ideas and known profile data compatible with earlier GPL OpenSCAD work for Elna cam discs.
