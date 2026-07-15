# Elna Cam Designer

A browser-based tool for designing Elna Supermatic cam discs by drawing stitch patterns.

## How to use

### Online (GitHub Pages)
Open: **https://qbarteczek.github.io/elna-supermatic-cams/**

### Locally
Just open `index.html` in any modern browser — no installation, no server needed.

## Features

- **Stitch editor** — draw the needle position over 18 cam positions (0–360°)
  - Draw mode: click/drag to set exact values
  - Smooth mode: brush that blends neighbours
  - Presets: Zigzag, Straight, Step, Wave, Satin
- **Live cam preview** — SVG cam profile updates in real time
- **Pictogram editor** — draw the stitch icon that appears on top of the disc
  - Draw/erase tools
  - "Auto from stitch" — generates icon automatically from the stitch pattern
- **Export**
  - `cam_XX_profile.json` — profile data file for the repository
  - `cam_XX.scad` — ready-to-render OpenSCAD file (includes `_elna_measured_common.scad`)

## Value mapping

| Profile value | Needle position | Cam radius |
|---|---|---|
| `0.0` | Centre | 18.55 mm |
| `1.5` | Half-width | 20.19 mm |
| `3.0` | Full width | 21.82 mm |

18 positions × 20° each = one full stitch cycle (360°).

## Output files

After export, place the files in:

```
models/measured_parametric_single_v1/profiles/cam_XX_profile.json
models/measured_parametric_single_v1/cam_XX.scad
```

Then open `cam_XX.scad` in OpenSCAD and press **F6** to render.

> ⚠️ Exported cams have status `candidate` — always verify physically before use in a machine.

## License

GPL-3.0-or-later.
