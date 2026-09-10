# Elna Supermatic Cam Generator User Guide

This repository features a built-in, versatile system for generating factory and custom stitch cam discs for the iconic Swiss sewing machines **Elna Supermatic**, **Elna SU**, and related models.

The generator includes a full catalog of **34 pre-configured cam profiles** (utility stitches, elastic stretch stitches, decorative scallops, waves, and geometric patterns) and an interactive 18-step designer for creating brand new stitches.

---

## 🌐 In-Browser Online Generator (Recommended!)

> [!TIP]
> **No installation required (no OpenSCAD, Python, or compiler needed)!**
> Access the generator directly in your browser:
> 👉 **[https://qbarteczek.github.io/elna-supermatic-cams/](https://qbarteczek.github.io/elna-supermatic-cams/)**

The application runs 100% locally in your web browser (desktop, tablet, or smartphone) and produces a production-ready, watertight binary `.stl` file in a fraction of a second (0.01 s).

---

## 3 Ways to Use the Generator

### Method 1: Web App Online / Offline (Easiest for Everyone)

1. **How to Launch:**
   * **Online (recommended):** Visit [https://qbarteczek.github.io/elna-supermatic-cams/](https://qbarteczek.github.io/elna-supermatic-cams/)
   * **Offline on PC:** Double click `Uruchom_Generator.bat` in the project root folder (or open `index.html` in any modern web browser).
2. **Features:**
   * **Real-Time 3D Cam Disc Viewer (WebGL / Three.js):** rotate, zoom, and inspect the real cam disc geometry with lower functional lobe, central bore, counterbore, driving pin slot, and embossed top markings.
   * **Virtual Fabric Seam Simulation:** live simulation showing what stitch pattern is formed on fabric over the 18 steps of the cam rotation. Click *„▶ Start Machine”* to watch the animated sewing action!
   * **Catalog of 34 Cams:** 1-click loading of any factory cam (01 through 34) with live search and wave previews.
   * **18-Step Profile Designer:** interactive height sliders for each needle position (`L`, `CL`, `C`, `CR`, `R` or continuous 0.0 – 3.0), wave generator tools (sine, zigzag, stairs, blind hem, invert).
   * **Custom Markings:** set custom cam numbers (e.g. `03`, `42`, `MY`) embossed in 3D on the disc surface.
3. **Download 3D Print File:**
   * Click the green button **„💾 Download STL for 3D Printing”** – in 0.01 s you get a watertight (2-manifold) `elna_cam_XX.stl` file ready for slicing in Bambu Studio, OrcaSlicer, PrusaSlicer, or Cura.
   * You can also download the OpenSCAD `.scad` code or export/import `.json` profiles.

---

### Method 2: In OpenSCAD (Customizer GUI)

For users who prefer working inside OpenSCAD:
1. Install [OpenSCAD](https://openscad.org/) (version 2021.01+).
2. Open [`tools/openscad/elna_cam_generator.scad`](../tools/openscad/elna_cam_generator.scad).
3. Enable the GUI parameter panel: **Window -> Customizer** (or uncheck *Hide Customizer*).
4. Select a preset from `PRESET` (`01` to `34`) or select `CUSTOM` to adjust the 18 step sliders.
5. Press **F5** (preview) or **F6** (render), then **F7** (Export as STL).

---

### Method 3: Python Command Line (`tools/generate_cam.py`)

CLI script for automated generation of `.scad` files and `.json` profiles:
```bash
# Generate a SCAD model from 18 values:
python tools/generate_cam.py --cam 03 --values 0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3 --mode stepped --out models/generated/cam_03.scad

# Generate from an existing JSON profile:
python tools/generate_cam.py --profile models/measured_parametric_single_v1/profiles/cam_10_profile.json --out output.scad
```

---

## Cam Catalog Overview (01–34)

| Cam | Stitch Name | Status | Cam Surface | Application |
|:---:|:---|:---:|:---:|:---|
| **01** | Elastic multi-step | candidate | smooth | Multi-step stretch stitch |
| **02** | Serpentine | candidate | smooth | Smooth wave / serpentine |
| **03** | Zigzag reference | uploaded-stl/reference | stepped | Standard reference zigzag |
| **04** | Long scallop | candidate | smooth | Extended decorative scallop |
| **05** | Scallop | candidate | smooth | Classic edge scallop |
| **06** | Wide zigzag | candidate | stepped | 2-step wide zigzag |
| **07** | Decorative zigzag | candidate | smooth | Saw-tooth decorative zigzag |
| **08** | Slanted bars | candidate | stepped | Slanted bar chevron |
| **09** | W stitch | candidate | stepped | W-shaped stitch |
| **10** | Blind hem | candidate | stepped | Blind hem hemming stitch |
| **11** | Arrows | candidate | smooth | Geometric arrowheads |
| **12** | Spindle | candidate | smooth | Satin spindle / teardrop |
| **13** | Source profile 13 | source-profile | smooth | Profile from base project |
| **14** | Loop wave | candidate | smooth | Looped waves |
| **15** | Triangle | candidate | stepped | Sharp triangles |
| **16** | Source profile 16 | source-profile | smooth | Profile from base project |
| **17** | Round pulses | candidate | stepped | Rounded pulse waves |
| **18** | Deep scallop | candidate | smooth | Deep satin scallop |
| **19** | Dense zigzag | candidate | stepped | Dense zigzag |
| **20** | Source profile 20 | source-profile | stepped | Profile from base project |
| **21** | Stair zigzag | candidate | smooth | Stepped staircase zigzag |
| **22** | Small lobes | candidate | smooth | Small rounded lobes |
| **23** | Sharp triangles | candidate | smooth | Sharpened triangle pattern |
| **24** | Small scallop | candidate | smooth | Fine edge scallop |
| **25** | Large sine wave | candidate | smooth | Large amplitude sine wave |
| **26** | Wave variant | candidate | smooth | Symmetric wave variation |
| **27** | Irregular pulse | candidate | stepped | Asymmetric pulse sequence |
| **28** | Vertical ticks | candidate | stepped | Vertical comb ticks |
| **29** | Comb alternate | candidate | smooth | Alternating comb pattern |
| **30** | Uneven wave | candidate | smooth | Asymmetric wave |
| **31** | Block sawtooth | candidate | stepped | Block sawtooth |
| **32** | Slanted bars | candidate | smooth | Smooth slanted bars |
| **33** | Source profile 33 | source-profile | smooth | Profile from base project |
| **34** | Extra decorative | candidate | smooth | Complex decorative stitch |

---

## ⚙️ Technical Specifications & Dimensions

All models are built upon measured dimensions from physical original cam discs and high-precision reference STL scans:

| Feature | Nominal Value | Machine Function |
|---|:---:|---|
| **Outer Diameter ($D_{max}$)** | **43.64 mm** | Clearance in cam compartment |
| **Total Height ($H_{total}$)** | **7.31 mm** | Main body (7.0 mm) + embossed badges (0.31 mm) |
| **Base Cam Radius ($R_{base}$)** | **18.55 mm** | Far-left needle position (throw = 0 mm) |
| **Max Cam Radius ($R_{max}$)** | **21.82 mm** | Far-right needle position (throw = 4 mm) |
| **Functional Lobe Height ($H_{lobe}$)** | **4.50 mm** | Lower portion engaging cam follower |
| **Cam Throw** | **3.27 mm** | Needle bar lever deflection range |
| **Shaft Bore Diameter ($D_{hole}$)** | **16.50 mm** | Spindle mount fit ($r = 8.25$ mm) |
| **Lower Counterbore Diameter ($D_{counterbore}$)** | **19.00 mm** | Spindle shoulder recess ($r = 9.50$ mm, $h = 1.5$ mm) |
| **Conical Lead-in ($H_{cone}$)** | **1.50 mm** | Tapered transition from 19 mm to 16.5 mm |
| **Drive Pin Slot** | **3.0 × 4.1 mm** | Locating slot for driving pin ($d = 5.5$ mm) |

---

## 🖨️ 3D Printing Recommendations (FDM)

1. **Filament Choice:**
   * **PETG (Recommended):** High wear resistance against metal cam followers, good flexibility, non-brittle.
   * **PLA / PLA+:** Excellent dimensional fidelity and stiffness, fine for domestic stitching.
   * **ABS / ASA / Nylon:** Optional for advanced users.
2. **Slicer Settings:**
   * **Layer Height:** `0.12 mm` or `0.16 mm` for smooth cam profiles without layer stepping.
   * **Perimeters / Walls:** `4` to `5` loops.
   * **Infill:** `40%–100%` (rigid disc prevents deflection under follower spring pressure).
   * **Orientation:** Flat on build plate, bottom face down.
   * **Supports:** **None** – designed to print 100% support-free.
