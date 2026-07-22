# Elna Supermatic Cam Discs — 3D Printable Replacements

> **3D-printable replacement cam discs for the vintage Elna Supermatic sewing machine.**  
> Parametric models for single cam discs, cams 01–34.

![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Web%20Designer-success?style=flat-square&logo=github)
![Status](https://img.shields.io/badge/Status-34%20Cams%20Generated-blue?style=flat-square)

---

## 🌟 Elna Supermatic Cam Designer

We have built a dedicated **Web App** to let you easily draw, edit, and export your own custom stitches!

**👉 [Open the Elna Cam Designer](https://qbarteczek.github.io/elna-supermatic-cams/tools/cam_designer/)**

Features:
- Draw stitch patterns on a 2D canvas (needle lateral position).
- Generate smooth curves or stepped zig-zag profiles.
- Draw the top icon pictogram (embossed on the disc).
- **Export immediately to JSON and `.scad` formats** ready for 3D printing.

---

## 🖨️ 3D Models & Printing Guide (Ready to Print)

**You don't need OpenSCAD!** We have pre-rendered all 34 cams into `.stl` format.

**👉 [Browse the `stls/` folder to download or view them in 3D directly on GitHub](stls/)**

---

### 🧩 Why the separate bottom ring (`_body` + `_ring`)? / Po co osobny pierścień?

Original Elna Supermatic cams feature a lower flange/rant at the bottom ($1.2\text{ mm}$ height). Printing the disc in one piece requires **3D printing supports**, which leave a rough, uneven surface on the functional cam edge. The sewing machine follower lever requires a smooth, precise surface to glide without friction.

By splitting each cam into two parts:
- **`cam_XX_body.stl`** (Main body): Has a flat recessed bottom. Prints flat on the bed **WITHOUT SUPPORTS** for maximum precision.
- **`cam_XX_ring.stl`** (Bottom ring): A flat $1.2\text{ mm}$ washer. Prints flat on the bed in under 2 minutes.

---

### 📖 Step-by-Step Guide / Instrukcja krok po kroku

#### 1️⃣ Printing / Druk 3D
- **Download:** Get both `cam_XX_body.stl` and `cam_XX_ring.stl` for your chosen cam (e.g. `cam_01_body.stl` and `cam_01_ring.stl`).
- **Slicer setup:** Place both parts **flat on the print bed**.
- **Supports:** Set supports to **DISABLED (NONE)**.
- **Material:** PETG or PLA (0.10 mm – 0.15 mm layer height for smooth curves).

#### 2️⃣ Assembly & Gluing / Składanie i Sklejanie
- Flip `cam_XX_body` upside down (bottom surface facing up).
- Place 2–3 small drops of **cyanoacrylate glue (Superglue / Kropelka)** into the bottom recess.
- Press `cam_XX_ring` flush into the recess and hold for 10 seconds.
- You now have a single, perfectly smooth, factory-accurate cam disc!

#### 3️⃣ Machine Installation / Montaż w maszynie Elna Supermatic
- Open the top cover of your Elna Supermatic machine.
- Hold the assembled cam with the **numbers & stitch diagram facing UP** (glued ring at the bottom).
- Place the cam onto the vertical shaft.
- Rotate slightly until the rectangular transport slot aligns with the metal drive pin on the shaft.
- Press down, close the lid, and you are ready to stitch!

*(Note: If you still prefer printing the whole cam in a single piece with supports, `cam_XX.stl` is also provided).*

---

## 🛠️ Modifying & Rendering

If you want to modify the dimensions or use OpenSCAD manually:
The core parametric logic lives in `models/measured_parametric_single_v1/_elna_measured_common.scad`.

**Command-line rendering:**
You can render all 34 cams in batch by running our rendering script (requires OpenSCAD in the root directory or in your PATH):
```bash
./tools/render_all_stls.sh
```

---

## 📖 Current Status

See [docs/STATUS.md](docs/STATUS.md) for the full verification status of each cam.

### Grounded / More Reliable Models
These models have the strongest basis:
| Cam | Basis |
|---:|---|
| **03** | uploaded STL/SCAD reference cam (Thingiverse) |
| **13** | known 18-position OpenSCAD profile |
| **16** | known 18-position OpenSCAD profile |
| **20** | known 18-position OpenSCAD profile |
| **33** | known 18-position OpenSCAD profile |

Other cams are included as **candidate profiles**. They use the same measured base, but their outer functional edge still needs verification from real top-down photos or original discs.

---

## 📁 File Structure

```text
docs/
  DIMENSIONS_FROM_UPLOADED_FILES.md   ← measured dimensions reference
  MEASURED_PARAMETRIC_INDEX.md        ← index of all cams and their profiles
  STATUS.md                           ← verification status per cam

models/
  measured_parametric_single_v1/
    _elna_measured_common.scad        ← shared parametric base (V2)
    cam_XX.scad                       ← per-cam scripts (generated)
    profiles/                         ← JSON data for the Web Designer

stls/                                 ← High-resolution, ready-to-print STL files

tools/                                ← Scripts and tools
  cam_designer/                       ← The Web Application (HTML/JS)
  render_all_stls.sh                  ← Bash script for batch rendering
  regenerate_scad.py                  ← Script converting JSON profiles to SCAD

photos/                               ← top-down reference photos
prints/                               ← print test notes
references/                           ← source STL/SCAD reference files
```

---

## ⚠️ Safety / Testing

> **These are mechanical parts for a sewing machine.**

Before using any printed cam:
1. Inspect dimensions with calipers.
2. Test fit without force.
3. Rotate the machine **by hand** for several cycles.
4. Test slowly at low speed.
5. Only then try normal powered stitching.

---

## 🤝 Contributing & License

Contributions are very welcome — especially top-down photos of original cams, confirmed stitch tests, and corrected profile JSON files! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

**License:** GPL-3.0-or-later.
