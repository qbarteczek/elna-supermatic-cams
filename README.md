# Generator krzywek Elna Supermatic / Elna Supermatic Cam Studio

*Dokument dwujęzyczny — polski niżej, English below. / Bilingual document — Polish first, English below.*

---

> [!TIP]
> ### 🌐 [URUCHOM GENERATOR KRZYWEK ONLINE (BEZ INSTALOWANIA PROGRAMÓW)](https://qbarteczek.github.io/elna-supermatic-cams/)
> **Dla każdego użytkownika maszyny:** wybierz dowolną krzywkę z katalogu 34 wzorów lub zaprojektuj własny ścieg w edytorze 18-krokowym, zobacz dysk w 3D oraz wirtualne przeszycie na tkaninie i pobierz gotowy plik `.stl` do druku 3D jednym kliknięciem (0.01 s)!
> 
> *English: [CLICK HERE TO LAUNCH THE 3D CAM GENERATOR IN BROWSER (NO SOFTWARE NEEDED)](https://qbarteczek.github.io/elna-supermatic-cams/)*

---

## PL

Otwarta biblioteka i interaktywny **generator krzywek ściegowych (cam discs)** do szwajcarskich maszyn **Elna Supermatic**, **Elna SU** i modeli pokrewnych. 

W odróżnieniu od maszyn ze stałymi bębnami wielościegowymi, Elna wykorzystuje pojedyncze, wymienne dyski montowane na obrotowym trzpieniu maszyny. Projekt łączy dokładne pomiary fizycznych dysków fabrycznych i skanów STL z parametrycznym generatorem 3D działającym w 100% w przeglądarce internetowej oraz w programie OpenSCAD.

### 🚀 Szybki start: 3 Sposoby korzystania z generatora

1. **🌐 Interaktywna aplikacja Webowa Online ([https://qbarteczek.github.io/elna-supermatic-cams/](https://qbarteczek.github.io/elna-supermatic-cams/)):**
   - **Podgląd 3D w czasie rzeczywistym (WebGL / Three.js):** natychmiastowe obracanie i oglądanie dysku z ząbkami wieńca, stożkowym otworem montażowym i gniazdem zabieraka.
   - **Bezpośrednie pobieranie STL:** klikasz *„💾 Pobierz STL do druku 3D”* i w 0.01 sekundy otrzymujesz szczelny (watertight / 2-manifold) plik `.stl` do wrzucenia do slicera (Bambu Studio, OrcaSlicer, PrusaSlicer, Cura).
   - **Wirtualne przeszycie na tkaninie:** podgląd nici na żywo dla 18 kroków pełnego obrotu dysku z animacją pracy maszyny.
   - **Katalog 34 krzywek fabrycznych:** 1-klikowe ładowanie profili od 01 do 34.
   - **Edytor 18-krokowy:** pełna swoboda tworzenia własnych ściegów z narzędziami generowania sinusoidy, schodków, zygzaka czy muszelki.
   - **Działanie offline:** wystarczy kliknąć dwukrotnie plik `Uruchom_Generator.bat` w głównym katalogu projektu.
2. **Panel okienkowy OpenSCAD Customizer GUI** ([`tools/openscad/elna_cam_generator.scad`](tools/openscad/elna_cam_generator.scad)): rozwijane menu wyboru krzywek 01–34 lub tryb Custom w oknie OpenSCAD (Window -> Customizer).
3. **Wiersz poleceń Python** ([`tools/generate_cam.py`](tools/generate_cam.py)): zautomatyzowane generowanie modeli `.scad` i profili `.json`.

Szczegółowa instrukcja obsługi: [`docs/GENERATOR.md`](docs/GENERATOR.md) (PL) oraz [`docs/GENERATOR.en.md`](docs/GENERATOR.en.md) (EN).

---

### ⚙️ Wymiary techniczne i pomiary nominalne

Dyski generowane są na podstawie ścisłych wymiarów nominalnych:
- **Średnica zewnętrzna:** 43.64 mm (promień maks. 21.82 mm)
- **Wysokość całkowita:** 7.31 mm (korpus 7.00 mm + oznaczenia 0.31 mm)
- **Wieniec roboczy:** wysokość 4.50 mm, promień bazowy 18.55 mm, promień maks. 21.82 mm
- **Skok krzywki (Throw):** 3.27 mm (przekłada się na szerokość ściegu 0–4 mm)
- **Otwór osi:** fi 16.50 mm (r=8.25 mm) z dolnym podtoczeniem fi 19.00 mm (h=1.5 mm) i stożkiem 1.5 mm
- **Gniazdo zabieraka napędowego:** szerokość 3.0 mm, długość 4.1 mm, głębokość 5.5 mm

---

### 📚 Pełny indeks 34 krzywek w repozytorium

| Numer | Nazwa ściegu | Status | Wieniec | Zastosowanie |
|:---:|:---|:---:|:---:|:---|
| **01** | Elastic multi-step | candidate | smooth | Ścieg elastyczny wielostopniowy |
| **02** | Serpentine | candidate | smooth | Serpentyna / płynna fala |
| **03** | Zigzag reference | reference STL/SCAD | stepped | Zygzak standardowy referencyjny |
| **04** | Long scallop | candidate | smooth | Długa muszelka ozdobna |
| **05** | Scallop | candidate | smooth | Klasyczna muszelka brzegowa |
| **06** | Wide zigzag | candidate | stepped | Zygzak szeroki dwustopniowy |
| **07** | Decorative zigzag | candidate | smooth | Zygzak ozdobny ząbkowany |
| **08** | Slanted bars | candidate | stepped | Paski skośne / jodełka |
| **09** | W stitch | candidate | stepped | Ścieg w kształcie litery W |
| **10** | Blind hem | candidate | stepped | Ścieg kryty do podszywania |
| **11** | Arrows | candidate | smooth | Strzałki geometryczne |
| **12** | Spindle | candidate | smooth | Wrzeciono / kropla satynowa |
| **13** | Source profile 13 | source-profile | smooth | Profil bazowy z projektu źródłowego |
| **14** | Loop wave | candidate | smooth | Pętle faliste |
| **15** | Triangle | candidate | stepped | Trójkąty ostre |
| **16** | Source profile 16 | source-profile | smooth | Profil bazowy z projektu źródłowego |
| **17** | Round pulses | candidate | stepped | Impulsy zaokrąglone |
| **18** | Deep scallop | candidate | smooth | Głęboka muszelka satynowa |
| **19** | Dense zigzag | candidate | stepped | Zygzak gęsty |
| **20** | Source profile 20 | source-profile | stepped | Profil bazowy z projektu źródłowego |
| **21** | Stair zigzag | candidate | smooth | Zygzak schodkowy |
| **22** | Small lobes | candidate | smooth | Drobne łuski |
| **23** | Sharp triangles | candidate | smooth | Trójkąty wyostrzone |
| **24** | Small scallop | candidate | smooth | Drobna muszelka |
| **25** | Large sine wave | candidate | smooth | Duża sinusoida |
| **26** | Wave variant | candidate | smooth | Wariant fali symetrycznej |
| **27** | Irregular pulse | candidate | stepped | Impuls nieregularny |
| **28** | Vertical ticks | candidate | stepped | Pionowe kreski / grzebyk |
| **29** | Comb alternate | candidate | smooth | Grzebyk naprzemienny |
| **30** | Uneven wave | candidate | smooth | Fala asymetryczna |
| **31** | Block sawtooth | candidate | stepped | Zęby piły blokowe |
| **32** | Slanted bars | candidate | smooth | Paski skośne gładkie |
| **33** | Source profile 33 | source-profile | smooth | Profil bazowy z projektu źródłowego |
| **34** | Extra decorative | candidate | smooth | Złożony ścieg dekoracyjny |

---

### 🖨️ Zalecenia dotyczące druku 3D (FDM)

- **Materiał:** **PETG** (zalecany ze względu na niski współczynnik tarcia i odporność na pękanie) lub **PLA / PLA+**.
- **Wysokość warstwy:** `0.12 mm` lub `0.16 mm` dla idealnie gładkiego profilu krzywki.
- **Wypełnienie / Ścianki:** 4–5 obrysów lub 100% wypełnienia (dysk musi być sztywny).
- **Pozycja na stole:** Płasko, spodem do stołu (brak podpór).

---

### 📁 Struktura projektu

```text
├── index.html                           # Główna aplikacja generatora online (GitHub Pages)
├── Uruchom_Generator.bat                # 1-klikowy launcher pod Windows
├── docs/
│   ├── GENERATOR.md                     # Instrukcja obsługi generatora (PL)
│   ├── GENERATOR.en.md                  # Generator user guide (EN)
│   ├── DIMENSIONS_FROM_UPLOADED_FILES.md# Raport z pomiarów referencyjnych
│   └── MEASURED_PARAMETRIC_INDEX.md     # Indeks krzywek parametrycznych
├── models/
│   ├── measured_parametric_single_v1/   # Gotowe modele OpenSCAD dla krzywek 01–34
│   │   ├── _elna_measured_common.scad   # Główna baza wymiarowa
│   │   ├── cam_01.scad ... cam_34.scad  # Pliki modeli
│   │   └── profiles/                    # Profile JSON dla wszystkich 34 krzywek
├── tools/
│   ├── build_index_html.py              # Skrypt kompilujący index.html z presetami
│   ├── generate_cam.py                  # Narzędzie CLI do generowania SCAD i JSON
│   ├── openscad/
│   │   └── elna_cam_generator.scad      # Generator OpenSCAD z panelem Customizer
│   └── generator/
│       └── index.html                   # Kopia aplikacji webowej do pracy offline
└── LICENSE                              # Licencja GPL-3.0
```

---

## EN

Open library and interactive **stitch cam disc generator** for the legendary Swiss sewing machines **Elna Supermatic**, **Elna SU**, and related models.

### 🌐 [LAUNCH 3D CAM GENERATOR IN BROWSER](https://qbarteczek.github.io/elna-supermatic-cams/)

- **No installation needed:** Runs in your browser with real-time WebGL 3D preview and instant 0.01 s binary STL download.
- **Full library of 34 factory cam profiles:** 1-click loading with live fabric stitch simulation.
- **18-Step Custom Designer:** Create completely custom stitch designs.
- **OpenSCAD GUI Customizer:** Available in `tools/openscad/elna_cam_generator.scad`.
- **3D Print Ready:** Watertight 2-manifold STL models tailored for PETG/PLA printing with zero supports.

Read the complete English guide in [`docs/GENERATOR.en.md`](docs/GENERATOR.en.md).

---

## Licencja / License

Projekt objęty licencją **GPL-3.0-or-later**.
Zachowaj informacje o autorach kodu bazowego i projektów źródłowych (ln-komandur/elna-cam-discs).
