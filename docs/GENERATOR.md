# Instrukcja obsługi generatora krzywek Elna Supermatic

Projekt zawiera wbudowany, uniwersalny system generowania własnych oraz fabrycznych dysków ściegowych (krzywek wymiennych) do kultowych szwajcarskich maszyn do szycia **Elna Supermatic**, **Elna SU** i modeli pokrewnych.

Dostępny jest pełny katalog **34 gotowych profili krzywek** (ściegi użytkowe, elastyczne, dekoracyjne muszelki, fale i wzory geometryczne) oraz możliwość projektowania zupełnie nowych, autorskich ściegów w edytorze 18-krokowym.

---

## 🌐 Generator Online w Przeglądarce (Zalecany dla każdego użytkownika!)

> [!TIP]
> **Nie musisz instalować żadnego oprogramowania (w tym OpenSCAD ani Pythona)!**
> Wejdź bezpośrednio na stronę generatora:
> 👉 **[https://qbarteczek.github.io/elna-supermatic-cams/](https://qbarteczek.github.io/elna-supermatic-cams/)**

Aplikacja działa w 100% w przeglądarce internetowej (na komputerze, tablecie i smartfonie) i umożliwia wygenerowanie oraz natychmiastowe pobranie gotowego pliku `.stl` do druku 3D w ułamku sekundy (0.01 s).

---

## 3 Sposoby korzystania z generatora

### Sposób 1: Aplikacja Webowa Online / Lokalna (Najwygodniejszy dla każdego!)

1. **Uruchomienie:**
   * **Online (zalecane):** Otwórz [https://qbarteczek.github.io/elna-supermatic-cams/](https://qbarteczek.github.io/elna-supermatic-cams/)
   * **Lokalnie na komputerze (bez internetu):** Kliknij dwukrotnie plik `Uruchom_Generator.bat` w głównym katalogu projektu (lub po prostu otwórz plik `index.html` w ulubionej przeglądarce).
2. **Możliwości studia projektowego:**
   * **Interaktywny podgląd 3D dysku (WebGL / Three.js):** obracaj myszką, przybliżaj i oglądaj rzeczywisty dysk krzywki z wieńcem funkcyjnym, stożkowym otworem montażowym, wpustem zabieraka i sygnaturami górnymi.
   * **Wirtualna symulacja ściegu na tkaninie:** dynamiczny podgląd przeszycia nici na materiale dla 18 kroków pełnego obrotu dysku. Przycisk *„▶ Uruchom maszynę”* uruchamia realistyczną animację pracy igły i posuwu materiału.
   * **Katalog 34 krzywek Elna:** błyskawiczny wybór fabrycznych dysków (od 01 do 34) z podglądem fali i wyszukiwarką.
   * **Edytor 18-krokowy:** interaktywne słupki z regulacją odchylenia igły (pozycje `L`, `CL`, `C`, `CR`, `R` lub płynne wartości 0.0 – 3.0), narzędzia generowania fal (sinusoida, zygzak, schodki, trójskok, ścieg kryty, inwersja).
   * **Dostosowanie oznaczeń:** wpisz własny numer dysku wytłaczany na tarczy (np. `03`, `42`, `MY`) oraz wybierz rodzaj piktogramu.
3. **Pobranie pliku do druku 3D:**
   * Kliknij zielony przycisk **„💾 Pobierz STL do druku 3D”** – w ułamku sekundy otrzymujesz gotowy, w 100% szczelny (watertight / 2-manifold) plik `elna_cam_XX.stl`, który możesz bezpośrednio otworzyć w Bambu Studio, OrcaSlicer, PrusaSlicer czy Cura!
   * Możesz także pobrać kod źródłowy `.scad` lub wyeksportować/zaimportować profil `.json`.

---

### Sposób 2: W programie OpenSCAD (Panel Customizer GUI)

Dla użytkowników preferujących pracę bezpośrednio w programie OpenSCAD:
1. Zainstaluj darmowy program [OpenSCAD](https://openscad.org/) (wersja 2021.01 lub nowsza).
2. Otwórz plik [`tools/openscad/elna_cam_generator.scad`](../tools/openscad/elna_cam_generator.scad).
3. W górnym menu OpenSCAD włącz panel parametrów: **Window -> Customizer** (lub odznacz *Hide Customizer*).
4. Wybierz gotową krzywkę z listy `PRESET` (`01` do `34`) lub wybierz `CUSTOM` i ustaw własne wartości 18 kroków za pomocą suwaków.
5. Wciśnij klawisz **F5** (szybki podgląd) lub **F6** (pełny render), a po zakończeniu obliczeń **F7** (Export as STL).

---

### Sposób 3: Wiersz poleceń Python (`tools/generate_cam.py`)

Skrypt CLI do zautomatyzowanego generowania modeli `.scad` i profili `.json`:
```bash
# Wygenerowanie modelu SCAD z zadanymi 18 wartościami:
python tools/generate_cam.py --cam 03 --values 0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3,0,3 --mode stepped --out models/generated/cam_03.scad

# Wygenerowanie modelu na podstawie istniejącego pliku JSON profilu:
python tools/generate_cam.py --profile models/measured_parametric_single_v1/profiles/cam_10_profile.json --out output.scad
```

---

## Pełny wykaz profili krzywek w katalogu (01–34)

| Numer | Nazwa ściegu | Status | Typ wieńca | Zastosowanie |
|:---:|:---|:---:|:---:|:---|
| **01** | Elastic multi-step | candidate | smooth | Ścieg elastyczny wielostopniowy |
| **02** | Serpentine | candidate | smooth | Serpentyna / płynna fala |
| **03** | Zigzag reference | uploaded-stl/reference | stepped | Zygzak standardowy referencyjny |
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

## ⚙️ Wymiary techniczne dysku Elna Supermatic

Wszystkie modele w generatorze bazują na dokładnych pomiarach oryginalnych dysków i referencyjnych skanów STL:

| Parametr konstrukcyjny | Wartość nominalna | Znaczenie w maszynie |
|---|:---:|---|
| **Średnica zewnętrzna ($D_{max}$)** | **43.64 mm** | Maksymalny gabaryt w gnieździe krzywek |
| **Wysokość całkowita ($H_{total}$)** | **7.31 mm** | Grubość korpusu (7.0 mm) + oznaczenia (0.31 mm) |
| **Promień bazowy wieńca ($R_{base}$)** | **18.55 mm** | Skrajna lewa pozycja igły (rzut = 0 mm) |
| **Promień maksymalny wieńca ($R_{max}$)** | **21.82 mm** | Skrajna prawa pozycja igły (rzut = 4 mm) |
| **Wysokość wieńca roboczego ($H_{lobe}$)** | **4.50 mm** | Dolna część współpracująca z popychaczem igielnicy |
| **Skok krzywki (Throw)** | **3.27 mm** | Zakres ruchu dźwigni igielnicy |
| **Średnica otworu osi ($D_{hole}$)** | **16.50 mm** | Otwór pasowany na trzpień napędowy (r=8.25 mm) |
| **Średnica dolnego podtoczenia ($D_{counterbore}$)** | **19.00 mm** | Pogłębienie na kołnierz osi (r=9.50 mm, h=1.5 mm) |
| **Stożek wprowadzający ($H_{cone}$)** | **1.50 mm** | Przejście stożkowe r=9.5 -> r=8.25 mm |
| **Wymiary gniazda zabieraka** | **3.0 × 4.1 mm** | Wpust na kołek napędowy (głębokość 5.5 mm) |

---

## 🖨️ Wskazówki dotyczące druku 3D (FDM)

1. **Materiał:**
   * **PETG (Zalecany):** Zapewnia doskonałą odporność na ścieranie przy tarciu metalowego popychacza, elastyczność i brak kruchości.
   * **PLA / PLA+:** Bardzo dobra dokładność wymiarowa i sztywność, odpowiednia do domowych zastosowań.
   * **ABS / ASA / Nylon:** Opcjonalnie dla zaawansowanych użytkowników.
2. **Ustawienia slicera:**
   * **Wysokość warstwy:** `0.12 mm` lub `0.16 mm` (zapewnia gładką krawędź krzywki bez schodkowania warstw).
   * **Obrysy (Perimeters / Walls):** `4` do `5` obrysów.
   * **Wypełnienie (Infill):** `40%–100%` (krzywka powinna być sztywna i solidna).
   * **Orientacja na stole:** Płasko, podstawą (dolną stroną z podtoczeniem) do stołu roboczego.
   * **Podpory:** **Brak** – model został zaprojektowany w sposób samonośny bez potrzeby stosowania podpór.
3. **Przygotowanie po wydruku:**
   * Oczyść ewentualne nitki (stringing) i sprawdź suwmiarką otwór centralny (16.5 mm). W razie potrzeby delikatnie przeszlifuj papierem ściernym gradacji 400–600 krawędź roboczą wieńca, aby zapewnić aksamitną pracę igielnicy.
