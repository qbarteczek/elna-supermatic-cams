# Workflow odtwarzania dysków Elna Supermatic

## Cel

Dla każdego dysku chcemy mieć:

- numer dysku,
- typ: single albo double,
- źródła referencyjne,
- profil 18-pozycyjny,
- plik `.scad`,
- podgląd renderu,
- poziom pewności,
- informację, czy model był fizycznie testowany.

## Dlaczego 18 pozycji?

Mechanizm krzywki wykonuje 18 pozycji/układów na jeden pełny obrót. Dlatego profil opisujemy jako tablicę 18 wartości.
Dzięki temu można porównywać oryginalne modele, zdjęcia i nowe projekty w jednym standardzie.

## Skala profilu

Używamy pięciu poziomów zgodnych z kodem bazowym:

| Token | Wartość | Znaczenie robocze |
|---|---:|---|
| `l` | 0.00 | lewa / minimalna pozycja |
| `cl` | 0.75 | między lewą a środkiem |
| `c` | 1.50 | środek |
| `cr` | 2.25 | między środkiem a prawą |
| `r` | 3.00 | prawa / maksymalna pozycja |

To nie jest jeszcze opis ściegu jako takiego — to opis geometrii krzywki.

## Kolejność pracy

1. Znajdź zdjęcie możliwie prostopadłe do dysku.
2. Zapisz link i opis źródła w `references/`.
3. Nie kopiuj zdjęcia do repo, jeśli nie masz prawa go użyć.
4. Uruchom ekstrakcję konturu:
   ```bash
   python tools/extract_profile_from_photo.py path/to/photo.jpg --out references/cam_XX_profile_raw.json
   ```
5. Ręcznie sprawdź/obróć profil względem otworu transportowego.
6. Utwórz finalny profil:
   ```bash
   models/generated/cam_XX_profile.json
   ```
7. Wygeneruj OpenSCAD:
   ```bash
   python tools/make_single_cam.py models/generated/cam_XX_profile.json --out models/generated/cam_XX.scad
   ```
8. Otwórz `.scad` w OpenSCAD i wyrenderuj.
9. Po wydruku testowym wpisz wynik w `docs/DISC_INDEX.md`.

## Zasada jakości

Nie oznaczamy modelu jako „pewny”, dopóki nie ma:
- dobrego zdjęcia lub pomiaru,
- zgodności orientacji,
- testu mechanicznego albo potwierdzenia od osoby mającej oryginalny dysk.
