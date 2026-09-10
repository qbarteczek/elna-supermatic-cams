/*
  Elna Supermatic Parametric Cam Generator (OpenSCAD Customizer)
  Projekt: https://github.com/qbarteczek/elna-supermatic-cams
  Licencja: GPL-3.0-or-later

  Instrukcja w OpenSCAD:
  1. Włącz panel parametrów: Window -> Customizer (lub odznacz "Hide Customizer").
  2. Wybierz gotową krzywkę z listy PRESET_CAM (01-34) lub wybierz "CUSTOM" i ustaw własne wartości 18 kroków.
  3. Wciśnij F5 (podgląd) lub F6 (pełny render), a następnie F7 (eksport STL do druku 3D).
*/

/* [Wybór Krzywki / Preset] */
// Wybierz fabryczny profil krzywki Elna (01 - 34) lub CUSTOM
PRESET = "03"; // ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "CUSTOM"]

// Własny numer wytłoczony na tarczy (np. 03, 42, A1)
CAM_NUMBER_TEXT = "03";

// Tryb wygładzania powierzchni wieńca krzywki
SURFACE_MODE = "auto"; // ["auto", "stepped", "smooth"]

/* [Własny profil 18-krokowy (aktywny tylko gdy PRESET = "CUSTOM")] */
// Wartości odchylenia igły dla 18 kroków cyklu (0.0 = lewa, 1.5 = środek, 3.0 = prawa):
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

/* [Pomiary i tolerancje druku 3D] */
$fn = 128;
OVERALL_R = 21.820;
BODY_R = 18.550;
TOTAL_H = 7.308;
BODY_TOP_H = 6.999;
LABEL_H = 0.309;
LOBE_H = 4.499;
THROW = 3.270;

// Otwór osi maszyny i zabierak
CENTER_HOLE_R = 8.250;
COUNTERBORE_R = 9.500;
COUNTERBORE_H = 1.500;
CONE_H = 1.500;

TRANSPORT_W = 3.000;
TRANSPORT_LEN = 4.100;
TRANSPORT_DEPTH = 5.500;
TRANSPORT_GAP = 1.000;

CUT_EPS = 0.08;

// Wbudowana baza 34 profili fabrycznych Elna
function get_preset_values(p) =
    (p == "01") ? [0.5, 1.2, 2.1, 2.8, 2.1, 1.2, 0.5, 1.2, 2.1, 2.8, 2.1, 1.2, 0.5, 1.2, 2.1, 2.8, 2.1, 1.2] :
    (p == "02") ? [1.5, 2.2, 2.8, 2.9, 2.2, 1.5, 0.8, 0.2, 0.1, 0.8, 1.5, 2.2, 2.8, 2.9, 2.2, 1.5, 0.8, 0.2] :
    (p == "03") ? [0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3] :
    (p == "04") ? [0.0, 0.6, 1.4, 2.2, 2.8, 3.0, 3.0, 2.8, 2.2, 1.4, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] :
    (p == "05") ? [0.0, 0.8, 1.8, 2.7, 3.0, 2.7, 1.8, 0.8, 0.0, 0.8, 1.8, 2.7, 3.0, 2.7, 1.8, 0.8, 0.0, 0.0] :
    (p == "06") ? [0.0, 0.0, 3.0, 3.0, 0.0, 0.0, 3.0, 3.0, 0.0, 0.0, 3.0, 3.0, 0.0, 0.0, 3.0, 3.0, 0.0, 0.0] :
    (p == "07") ? [0.0, 1.5, 3.0, 1.5, 0.0, 1.5, 3.0, 1.5, 0.0, 1.5, 3.0, 1.5, 0.0, 1.5, 3.0, 1.5, 0.0, 1.5] :
    (p == "08") ? [0.0, 0.0, 1.0, 2.0, 3.0, 0.0, 0.0, 1.0, 2.0, 3.0, 0.0, 0.0, 1.0, 2.0, 3.0, 0.0, 0.0, 1.5] :
    (p == "09") ? [0.0, 3.0, 1.5, 3.0, 0.0, 0.0, 3.0, 1.5, 3.0, 0.0, 0.0, 3.0, 1.5, 3.0, 0.0, 0.0, 0.0, 0.0] :
    (p == "10") ? [1.5, 1.5, 1.5, 0.0, 3.0, 0.0, 1.5, 1.5, 1.5, 0.0, 3.0, 0.0, 1.5, 1.5, 1.5, 0.0, 3.0, 0.0] :
    (p == "11") ? [0.0, 1.0, 2.0, 3.0, 1.5, 0.0, 1.0, 2.0, 3.0, 1.5, 0.0, 1.0, 2.0, 3.0, 1.5, 0.0, 0.0, 0.0] :
    (p == "12") ? [0.0, 0.5, 1.5, 2.5, 3.0, 2.5, 1.5, 0.5, 0.0, 0.5, 1.5, 2.5, 3.0, 2.5, 1.5, 0.5, 0.0, 0.0] :
    (p == "13") ? [0.0, 0.75, 1.5, 2.25, 3.0, 2.25, 1.5, 0.75, 0.0, 0.75, 1.5, 2.25, 3.0, 2.25, 1.5, 0.75, 0.0, 0.0] :
    (p == "14") ? [0.2, 0.8, 1.8, 2.8, 2.0, 1.0, 0.2, 0.8, 1.8, 2.8, 2.0, 1.0, 0.2, 0.8, 1.8, 2.8, 2.0, 1.0] :
    (p == "15") ? [0.0, 1.0, 2.0, 3.0, 0.0, 0.0, 1.0, 2.0, 3.0, 0.0, 0.0, 1.0, 2.0, 3.0, 0.0, 0.0, 0.0, 0.0] :
    (p == "16") ? [0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0] :
    (p == "17") ? [0.0, 0.0, 2.8, 2.8, 0.0, 0.0, 2.8, 2.8, 0.0, 0.0, 2.8, 2.8, 0.0, 0.0, 2.8, 2.8, 0.0, 0.0] :
    (p == "18") ? [0.0, 0.0, 1.0, 2.5, 3.0, 2.5, 1.0, 0.0, 0.0, 1.0, 2.5, 3.0, 2.5, 1.0, 0.0, 0.0, 0.0, 0.0] :
    (p == "19") ? [0.0, 3.0, 0.0, 3.0, 0.0, 3.0, 0.0, 3.0, 0.0, 3.0, 0.0, 3.0, 0.0, 3.0, 0.0, 3.0, 0.0, 3.0] :
    (p == "20") ? [0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0] :
    (p == "21") ? [0.0, 0.8, 1.6, 2.4, 3.0, 2.0, 1.0, 0.0, 0.8, 1.6, 2.4, 3.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0] :
    (p == "22") ? [0.0, 1.8, 0.0, 1.8, 0.0, 1.8, 0.0, 1.8, 0.0, 1.8, 0.0, 1.8, 0.0, 1.8, 0.0, 1.8, 0.0, 0.0] :
    (p == "23") ? [0.0, 1.5, 3.0, 1.5, 0.0, 0.0, 1.5, 3.0, 1.5, 0.0, 0.0, 1.5, 3.0, 1.5, 0.0, 0.0, 0.0, 0.0] :
    (p == "24") ? [0.5, 1.2, 2.2, 2.9, 2.2, 1.2, 0.5, 1.2, 2.2, 2.9, 2.2, 1.2, 0.5, 1.2, 2.2, 2.9, 2.2, 1.2] :
    (p == "25") ? [0.2, 0.5, 1.2, 2.2, 2.8, 3.0, 2.8, 2.2, 1.2, 0.5, 0.2, 0.5, 1.2, 2.2, 2.8, 3.0, 2.8, 1.5] :
    (p == "26") ? [1.5, 2.2, 2.8, 2.2, 1.5, 0.8, 0.2, 0.8, 1.5, 2.2, 2.8, 2.2, 1.5, 0.8, 0.2, 0.8, 1.5, 1.5] :
    (p == "27") ? [0.0, 2.8, 0.5, 2.8, 0.0, 0.0, 2.8, 0.5, 2.8, 0.0, 0.0, 2.8, 0.5, 2.8, 0.0, 0.0, 0.0, 0.0] :
    (p == "28") ? [0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0] :
    (p == "29") ? [0.0, 2.5, 0.0, 2.5, 0.0, 2.5, 0.0, 2.5, 0.0, 2.5, 0.0, 2.5, 0.0, 2.5, 0.0, 2.5, 0.0, 0.0] :
    (p == "30") ? [0.5, 1.5, 2.8, 2.0, 0.8, 0.2, 1.0, 2.5, 3.0, 1.8, 0.5, 0.2, 1.2, 2.6, 2.2, 1.0, 0.4, 0.2] :
    (p == "31") ? [0.0, 0.0, 3.0, 3.0, 1.5, 1.5, 0.0, 0.0, 3.0, 3.0, 1.5, 1.5, 0.0, 0.0, 3.0, 3.0, 1.5, 1.5] :
    (p == "32") ? [0.0, 0.0, 0.8, 1.6, 2.4, 3.0, 0.0, 0.0, 0.8, 1.6, 2.4, 3.0, 0.0, 0.0, 0.8, 1.6, 2.4, 3.0] :
    (p == "33") ? [0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0, 0.0, 1.5, 3.0] :
    (p == "34") ? [0.2, 0.8, 2.0, 2.9, 3.0, 2.2, 1.0, 0.2, 0.0, 0.5, 1.5, 2.7, 3.0, 2.5, 1.2, 0.4, 0.1, 0.0] :
    [STEP_01, STEP_02, STEP_03, STEP_04, STEP_05, STEP_06, STEP_07, STEP_08, STEP_09,
     STEP_10, STEP_11, STEP_12, STEP_13, STEP_14, STEP_15, STEP_16, STEP_17, STEP_18];

function is_stepped_preset(p) =
    (p == "03" || p == "06" || p == "08" || p == "09" || p == "10" || p == "15" ||
     p == "17" || p == "19" || p == "20" || p == "27" || p == "28" || p == "31");

values = (PRESET == "CUSTOM") ?
    [STEP_01, STEP_02, STEP_03, STEP_04, STEP_05, STEP_06, STEP_07, STEP_08, STEP_09,
     STEP_10, STEP_11, STEP_12, STEP_13, STEP_14, STEP_15, STEP_16, STEP_17, STEP_18] :
    get_preset_values(PRESET);

resolved_mode = (SURFACE_MODE == "auto") ?
    ((PRESET == "CUSTOM") ? "stepped" : (is_stepped_preset(PRESET) ? "stepped" : "smooth")) :
    SURFACE_MODE;

active_number = (PRESET == "CUSTOM") ? CAM_NUMBER_TEXT : PRESET;

// Generowanie punktów wielokąta krzywki
function cam_radius_at(idx) = BODY_R + (max(0, min(3, values[idx])) / 3.0) * THROW;

function generate_stepped_points() = [
    for (i = [0:17])
        let (r = cam_radius_at(i), a = i * 20.0)
        each [
            [r * sin(a - 4.5), r * cos(a - 4.5)],
            [r * sin(a + 4.5), r * cos(a + 4.5)]
        ]
];

function generate_smooth_points(samples = 144) = [
    for (i = [0:samples-1])
        let (
            t_glob = (i / samples) * 18.0,
            idx1 = floor(t_glob) % 18,
            idx0 = (idx1 + 17) % 18,
            idx2 = (idx1 + 1) % 18,
            idx3 = (idx1 + 2) % 18,
            t = t_glob - floor(t_glob),
            p0 = values[idx0], p1 = values[idx1], p2 = values[idx2], p3 = values[idx3],
            v_spline = 0.5 * ((2*p1) + (-p0 + p2)*t + (2*p0 - 5*p1 + 4*p2 - p3)*(t^2) + (-p0 + 3*p1 - 3*p2 + p3)*(t^3)),
            v_clamp = max(0, min(3, v_spline)),
            r = BODY_R + (v_clamp / 3.0) * THROW,
            ang = i * (360.0 / samples)
        )
        [r * sin(ang), r * cos(ang)]
];

poly_points = (resolved_mode == "stepped") ? generate_stepped_points() : generate_smooth_points(144);

// Geometria dysku Elna Supermatic
module annulus(h, ro, ri) {
    difference() {
        cylinder(h=h, r=ro);
        translate([0,0,-CUT_EPS]) cylinder(h=h+2*CUT_EPS, r=ri);
    }
}

module elna_cam_solid() {
    difference() {
        union() {
            // Dolny wieniec funkcyjny o zmiennym profilu
            linear_extrude(height=LOBE_H)
                polygon(points=poly_points);

            // Górny okrągły korpus dysku
            cylinder(h=BODY_TOP_H, r=BODY_R);

            // Górny wąski rant ozdobny
            translate([0,0,BODY_TOP_H - 0.22])
                annulus(h=0.22, ro=BODY_R + 0.10, ri=BODY_R - 0.45);

            // Wewnętrzny pierścień wokół otworu osi
            translate([0,0,BODY_TOP_H - 0.45])
                annulus(h=0.45, ro=CENTER_HOLE_R + 2.05, ri=CENTER_HOLE_R + 0.35);

            // Wytłoczenia na górnej ściance
            // 1. Owal/pierścień z numerem
            translate([11.55, -7.25, BODY_TOP_H])
                annulus(h=LABEL_H, ro=2.95, ri=2.35);

            translate([11.55, -7.25, BODY_TOP_H])
                linear_extrude(height=LABEL_H)
                    text(active_number, size=3.2, halign="center", valign="center", font="Liberation Sans:style=Bold");

            // 2. Pierścień ozdobny naprzeciwko
            translate([-11.80, -7.25, BODY_TOP_H])
                annulus(h=LABEL_H, ro=2.80, ri=2.20);

            // 3. Napisy fabryczne SWISS MADE
            translate([-14.35, 0.80, BODY_TOP_H])
                rotate([0,0,90])
                    linear_extrude(height=LABEL_H)
                        text("SWISS", size=2.1, halign="center", valign="center", font="Liberation Sans:style=Bold");

            translate([0.0, -15.15, BODY_TOP_H])
                linear_extrude(height=LABEL_H)
                    text("MADE", size=2.0, halign="center", valign="center", font="Liberation Sans:style=Bold");

            // 4. Znaczniki referencyjne na łuku
            for (a = [208:10:332]) {
                rotate([0,0,a])
                    translate([BODY_R - 0.55, 0, BODY_TOP_H])
                        cube([0.62, 0.34, LABEL_H], center=true);
            }
        }

        // Otwory montażowe
        // Główny otwór na wałek maszyny
        translate([0,0,-CUT_EPS])
            cylinder(h=TOTAL_H + 2*CUT_EPS, r=CENTER_HOLE_R);

        // Dolny counterbore
        translate([0,0,-CUT_EPS])
            cylinder(h=COUNTERBORE_H + CUT_EPS, r=COUNTERBORE_R);

        // Stożkowe przejście
        translate([0,0,COUNTERBORE_H - CUT_EPS])
            cylinder(h=CONE_H, r1=COUNTERBORE_R, r2=CENTER_HOLE_R);

        // Wpust zabieraka transportowego
        translate([0, COUNTERBORE_R + TRANSPORT_GAP + TRANSPORT_LEN/2, TRANSPORT_DEPTH/2 - CUT_EPS])
            cube(size=[TRANSPORT_W, TRANSPORT_LEN, TRANSPORT_DEPTH], center=true);
    }
}

// Wywołanie głównego modelu
elna_cam_solid();
