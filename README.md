# Elna Supermatic Cam Discs — measured parametric models

> **3D-printable replacement cam discs for the vintage Elna Supermatic sewing machine.**  
> OpenSCAD parametric models for single cam discs, cams 01–34.

---

## What is this?

The **Elna Supermatic** is a vintage Swiss sewing machine (produced ~1952–1970) that uses
interchangeable plastic cam discs to produce decorative stitch patterns. Over time these discs
break, warp, or get lost. This repository provides parametric
[OpenSCAD](https://openscad.org/) models for 3D-printing replacement cams.

The model set is based on a measured parametric base derived from uploaded reference STL/SCAD
files for cam **03 / zigzag**.  
The goal is to preserve the original Elna-style body, holes, height and top layout while
changing only:

1. the lower functional cam edge,
2. the cam number,
3. the stitch pictogram.

---

## Prerequisites

- **[OpenSCAD](https://openscad.org/)** 2021.01 or newer
- **3D printer** capable of ≥ 0.1 mm layer height
- **Recommended material:** PETG or rigid PLA (low flex, dimensionally stable)

---

## Quick start

1. Clone or download this repository.
2. Open the reference cam in OpenSCAD:
   ```text
   models/measured_parametric_single_v1/cam_03.scad
   ```
3. Press **F6** to render, then **F7** to export STL.
4. Compare with the grounded models listed below before printing others.

---

## Current status

The most important folder is:

```text
models/measured_parametric_single_v1/
```

It contains generated `.scad` files for single cams `01–34`.

See [docs/STATUS.md](docs/STATUS.md) for the full verification status of each cam.

### Grounded / more reliable models

These models have the strongest basis:

| Cam | Basis |
|---:|---|
| 03 | uploaded STL/SCAD reference cam |
| 13 | known 18-position OpenSCAD profile |
| 16 | known 18-position OpenSCAD profile |
| 20 | known 18-position OpenSCAD profile |
| 33 | known 18-position OpenSCAD profile |

Other cams are included as **candidate profiles**. They use the same measured base, but
their outer functional edge still needs verification from real top-down photos, scans or
original discs.

---

## Key dimensions

Main dimensions are documented in:

```text
docs/DIMENSIONS_FROM_UPLOADED_FILES.md
```

| Parameter | Value |
|---|---:|
| Overall diameter | ~43.64 mm |
| Overall height | 7.308 mm |
| Lower cam lobe height | 4.499 mm |
| Upper round body radius | ~18.55 mm |
| Max functional lobe radius | ~21.82 mm |
| Center hole radius | 8.25 mm |

---

## Design rule

**The body is fixed.** Only the functional edge, number and stitch icon should change between
single cams.

This avoids the earlier mistake of rebuilding the entire cam body and losing the Elna geometry.

---

## File structure

```text
docs/
  DIMENSIONS_FROM_UPLOADED_FILES.md   ← measured dimensions reference
  MEASURED_PARAMETRIC_INDEX.md        ← index of all cams and their profiles
  MEASUREMENT_PROTOCOL.md             ← how to measure a physical cam
  STATUS.md                           ← verification status per cam

models/
  measured_parametric_single_v1/
    _elna_measured_common.scad        ← shared parametric base (do not edit per-cam)
    cam_01.scad
    ...
    cam_34.scad
    profiles/
      cam_01_profile.json
      ...
      cam_34_profile.json

photos/                               ← top-down reference photos
prints/                               ← print test notes
references/                           ← source STL/SCAD reference files
tools/                                ← helper scripts
```

---

## Rendering

Open any `.scad` file in OpenSCAD and render/export STL.

**Command-line rendering** (batch):

```bash
openscad -o output/cam_03.stl models/measured_parametric_single_v1/cam_03.scad
```

---

## Safety / testing

> ⚠️ **These are mechanical parts for a sewing machine.**

Before using any printed cam:

1. Inspect dimensions with calipers.
2. Test fit without force.
3. Rotate the machine **by hand** for several cycles.
4. Test slowly at low speed.
5. Only then try normal powered stitching.

**Do not mark a cam as verified until it has been physically tested.**

---

## Contributing

Contributions are very welcome — especially:
- top-down photos of original Elna Supermatic cams,
- measured dimensions from physical discs,
- confirmed stitch tests,
- corrected profile JSON files.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## License

GPL-3.0-or-later.

This repo builds on ideas and known profile data compatible with earlier GPL OpenSCAD work
for Elna cam discs.
