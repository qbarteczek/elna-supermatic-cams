/*
  Elna Supermatic Parametric Cam Generator (OpenSCAD Customizer)
  Projekt: https://github.com/qbarteczek/elna-supermatic-cams
  Licencja: GPL-3.0-or-later

  Instrukcja w OpenSCAD:
  1. Włącz panel parametrów: Window -> Customizer (lub odznacz "Hide Customizer").
  2. Wybierz gotową krzywkę z listy PRESET (01-34) lub "CUSTOM" i ustaw własne wartości 18 kroków.
  3. Wybierz element (PART): cały dysk, korpus do druku albo uniwersalny pierścień.
  4. F5 (podgląd), F6 (pełny render), F7 (eksport STL).

  Geometria, wymiary, oznaczenia i wzór profilu pochodzą ze wspólnej biblioteki
  models/measured_parametric_single_v1/_elna_measured_common.scad - ten sam kod
  generuje pliki w stls/. Plik działa tylko wewnątrz repozytorium (ścieżka include niżej).
*/

/* [Wybór krzywki] */
// Fabryczny profil krzywki Elna (01 - 34) lub CUSTOM
PRESET = "03"; // ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "CUSTOM"]

// Element do wygenerowania
PART = "body"; // [body:Korpus do druku (bez pierścienia), ring:Uniwersalny pierścień dolny, assembly:Cały dysk w jednym kawałku]

// Własny numer na tarczy (puste = numer presetu, dla CUSTOM: "00")
CAM_NUMBER_TEXT = "";

// Tryb wieńca krzywki (auto = jak w presecie, CUSTOM: stepped)
SURFACE_MODE = "auto"; // [auto, stepped, smooth]

// Piktogram ściegu (auto = jak w presecie, CUSTOM: zigzag)
ICON = "auto"; // [auto, zigzag, step, wave, scallop, saw, blind, arrows, spindle, pulse, comb, hi-lo]

// Wypukłość wierzchu w mm (0 = płaski jak oryginał, 1.5 = kopułka z wersji v2)
DOME_CROWN = 0.0; // [0:0.25:2]

/* [Własny profil 18-krokowy (tylko PRESET = CUSTOM)] */
// Wychylenie igły w krokach cyklu (0.0 = lewo, 1.5 = środek, 3.0 = prawo)
STEP_01 = 0.0; // [0.0:0.25:3.0]
STEP_02 = 3.0; // [0.0:0.25:3.0]
STEP_03 = 0.0; // [0.0:0.25:3.0]
STEP_04 = 3.0; // [0.0:0.25:3.0]
STEP_05 = 0.0; // [0.0:0.25:3.0]
STEP_06 = 3.0; // [0.0:0.25:3.0]
STEP_07 = 0.0; // [0.0:0.25:3.0]
STEP_08 = 3.0; // [0.0:0.25:3.0]
STEP_09 = 0.0; // [0.0:0.25:3.0]
STEP_10 = 3.0; // [0.0:0.25:3.0]
STEP_11 = 0.0; // [0.0:0.25:3.0]
STEP_12 = 3.0; // [0.0:0.25:3.0]
STEP_13 = 0.0; // [0.0:0.25:3.0]
STEP_14 = 3.0; // [0.0:0.25:3.0]
STEP_15 = 0.0; // [0.0:0.25:3.0]
STEP_16 = 3.0; // [0.0:0.25:3.0]
STEP_17 = 0.0; // [0.0:0.25:3.0]
STEP_18 = 3.0; // [0.0:0.25:3.0]

/* [Hidden] */
include <../../models/measured_parametric_single_v1/_elna_measured_common.scad>;

dome_crown = DOME_CROWN;   // nadpisuje wartość z biblioteki

// <generated:presets> — written by tools/regenerate_scad.py, do not edit by hand
function preset_values(p) =
    (p == "01") ? [0.5,1.2,2.1,2.8,2.1,1.2,0.5,1.2,2.1,2.8,2.1,1.2,0.5,1.2,2.1,2.8,2.1,1.2] :
    (p == "02") ? [1.5,2.2,2.8,2.9,2.2,1.5,0.8,0.2,0.1,0.8,1.5,2.2,2.8,2.9,2.2,1.5,0.8,0.2] :
    (p == "03") ? [0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3] :
    (p == "04") ? [0,0.2,0.8,1.8,2.7,3.0,2.7,1.8,0.8,0.2,0,0.2,0.8,1.8,2.7,3.0,2.7,1.8] :
    (p == "05") ? [0,0.8,2.2,3,2.2,0.8,0,0.8,2.2,3,2.2,0.8,0,0.8,2.2,3,2.2,0.8] :
    (p == "06") ? [0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5] :
    (p == "07") ? [0,2.6,1.2,3,0.4,2.8,0,2.6,1.2,3,0.4,2.8,0,2.6,1.2,3,0.4,2.8] :
    (p == "08") ? [0,0.5,1,1.5,2,2.5,3,2.5,2,1.5,1,0.5,0,0.5,1,1.5,2,2.5] :
    (p == "09") ? [0,3,1,3,0,3,1,3,0,3,1,3,0,3,1,3,0,3] :
    (p == "10") ? [1.5,1.5,1.5,0,3,0,1.5,1.5,1.5,0,3,0,1.5,1.5,1.5,0,3,0] :
    (p == "11") ? [0,3,0,0.5,2.5,0.5,0,3,0,0.5,2.5,0.5,0,3,0,0.5,2.5,0.5] :
    (p == "12") ? [0,1,2,3,2,1,0,1,2,3,2,1,0,1,2,3,2,1] :
    (p == "13") ? [1.5,0,1.5,0,1.5,0,1.5,0,1.5,1.5,3,1.5,3,1.5,3,1.5,3,1.5] :
    (p == "14") ? [0.5,1.4,2.7,3,2.3,1.2,0.2,0,0.7,1.8,2.9,2.8,1.7,0.6,0.1,0.8,1.9,2.8] :
    (p == "15") ? [0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5] :
    (p == "16") ? [1.5,2.25,1.5,0.75,1.5,2.25,3,2.25,1.5,0.75,0,0.75,1.5,2.25,1.5,0.75,1.5,1.5] :
    (p == "17") ? [1.5,2.7,3,2.7,1.5,0.3,0,0.3,1.5,2.7,3,2.7,1.5,0.3,0,0.3,1.5,2.7] :
    (p == "18") ? [0,0.4,1.4,2.6,3,2.6,1.4,0.4,0,0.4,1.4,2.6,3,2.6,1.4,0.4,0,0.4] :
    (p == "19") ? [0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3] :
    (p == "20") ? [0,3,0,3,0,3,0,3,0,2.25,0.75,2.25,0.75,2.25,0.75,2.25,0.75,2.25] :
    (p == "21") ? [0,0.6,1.2,1.8,2.4,3,2.4,1.8,1.2,0.6,0,0.6,1.2,1.8,2.4,3,2.4,1.8] :
    (p == "22") ? [1.5,2.6,2.2,1.5,0.8,0.4,1.5,2.6,2.2,1.5,0.8,0.4,1.5,2.6,2.2,1.5,0.8,0.4] :
    (p == "23") ? [0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5] :
    (p == "24") ? [0.2,1.2,2.7,3,2.7,1.2,0.2,1.2,2.7,3,2.7,1.2,0.2,1.2,2.7,3,2.7,1.2] :
    (p == "25") ? [1.5,2.5,3,2.5,1.5,0.5,0,0.5,1.5,2.5,3,2.5,1.5,0.5,0,0.5,1.5,2.5] :
    (p == "26") ? [0.2,1,2.2,3,2.4,1.6,0.8,0,0.6,1.8,2.8,2.6,1.4,0.4,0.2,1.2,2.5,3] :
    (p == "27") ? [1.5,2.6,0.5,2.8,1,2.4,0.3,2.9,1.2,2.5,0.6,2.7,0.4,2.8,1,2.4,0.6,2.6] :
    (p == "28") ? [1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3,1.5,0,1.5,3] :
    (p == "29") ? [0,3,0,3,1.5,3,1.5,0,1.5,0,3,0,3,1.5,3,1.5,0,1.5] :
    (p == "30") ? [1.5,2.8,1,2.4,0.4,1.9,0,1.2,2.6,1.5,2.9,1.1,2.2,0.2,1.5,0.1,1.6,2.7] :
    (p == "31") ? [0,3,3,0,1.5,3,0,3,3,0,1.5,3,0,3,3,0,1.5,3] :
    (p == "32") ? [0,0.5,1,1.5,2,2.5,3,0,0.5,1,1.5,2,2.5,3,0,0.5,1,1.5] :
    (p == "33") ? [0,3,0,3,0,3,0,3,0,1.5,0,1.5,0,1.5,0,1.5,0,1.5] :
    (p == "34") ? [0,3,3,0,0.5,2.5,2.5,0.5,0,3,3,0,0.5,2.5,2.5,0.5,0,3] :
    undef;
function preset_mode(p) =
    (p == "01") ? "smooth" :
    (p == "02") ? "smooth" :
    (p == "03") ? "stepped" :
    (p == "04") ? "smooth" :
    (p == "05") ? "smooth" :
    (p == "06") ? "stepped" :
    (p == "07") ? "stepped" :
    (p == "08") ? "stepped" :
    (p == "09") ? "stepped" :
    (p == "10") ? "stepped" :
    (p == "11") ? "stepped" :
    (p == "12") ? "stepped" :
    (p == "13") ? "stepped" :
    (p == "14") ? "smooth" :
    (p == "15") ? "stepped" :
    (p == "16") ? "smooth" :
    (p == "17") ? "smooth" :
    (p == "18") ? "smooth" :
    (p == "19") ? "stepped" :
    (p == "20") ? "stepped" :
    (p == "21") ? "stepped" :
    (p == "22") ? "smooth" :
    (p == "23") ? "stepped" :
    (p == "24") ? "smooth" :
    (p == "25") ? "smooth" :
    (p == "26") ? "smooth" :
    (p == "27") ? "stepped" :
    (p == "28") ? "stepped" :
    (p == "29") ? "stepped" :
    (p == "30") ? "smooth" :
    (p == "31") ? "stepped" :
    (p == "32") ? "stepped" :
    (p == "33") ? "stepped" :
    (p == "34") ? "stepped" :
    "stepped";
function preset_icon(p) =
    (p == "01") ? "step" :
    (p == "02") ? "wave" :
    (p == "03") ? "zigzag" :
    (p == "04") ? "scallop" :
    (p == "05") ? "scallop" :
    (p == "06") ? "zigzag" :
    (p == "07") ? "saw" :
    (p == "08") ? "step" :
    (p == "09") ? "saw" :
    (p == "10") ? "blind" :
    (p == "11") ? "arrows" :
    (p == "12") ? "spindle" :
    (p == "13") ? "step" :
    (p == "14") ? "wave" :
    (p == "15") ? "saw" :
    (p == "16") ? "wave" :
    (p == "17") ? "pulse" :
    (p == "18") ? "scallop" :
    (p == "19") ? "comb" :
    (p == "20") ? "step" :
    (p == "21") ? "step" :
    (p == "22") ? "pulse" :
    (p == "23") ? "saw" :
    (p == "24") ? "scallop" :
    (p == "25") ? "wave" :
    (p == "26") ? "wave" :
    (p == "27") ? "pulse" :
    (p == "28") ? "comb" :
    (p == "29") ? "comb" :
    (p == "30") ? "wave" :
    (p == "31") ? "saw" :
    (p == "32") ? "step" :
    (p == "33") ? "hi-lo" :
    (p == "34") ? "saw" :
    "zigzag";
// </generated:presets>

custom_values = [STEP_01, STEP_02, STEP_03, STEP_04, STEP_05, STEP_06, STEP_07, STEP_08, STEP_09,
                 STEP_10, STEP_11, STEP_12, STEP_13, STEP_14, STEP_15, STEP_16, STEP_17, STEP_18];

is_custom     = (PRESET == "CUSTOM");
values        = is_custom ? custom_values : preset_values(PRESET);
resolved_mode = (SURFACE_MODE != "auto") ? SURFACE_MODE : (is_custom ? "stepped" : preset_mode(PRESET));
resolved_icon = (ICON != "auto") ? ICON : (is_custom ? "zigzag" : preset_icon(PRESET));
active_number = (CAM_NUMBER_TEXT != "") ? CAM_NUMBER_TEXT : (is_custom ? "00" : PRESET);

poly_points = elna_profile_points(values, resolved_mode);
icon_pts    = elna_icon_points(resolved_icon);

if (PART == "ring")
    universal_ring();
else if (PART == "assembly")
    elna_single_cam(profile_points=poly_points, icon_points=icon_pts, number_text=active_number);
else
    elna_cam_body(profile_points=poly_points, icon_points=icon_pts, number_text=active_number);
