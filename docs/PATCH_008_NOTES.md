# Patch 008 — measured parametric base

> **Note:** This document is kept for historical reference.
> The current project status and design rules are described in the main [README.md](../README.md).

---

This patch fixes the earlier mistake: it does not try to edit the frozen mesh SCAD.

Instead it builds a clean parametric OpenSCAD base using the dimensions read from the
uploaded STL/SCAD files.

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
