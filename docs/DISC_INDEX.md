# Indeks dysków Elna Supermatic

Statusy:
- `source` — model istnieje w projekcie bazowym,
- `profile` — mamy profil 18-pozycyjny,
- `draft` — wygenerowany model roboczy,
- `photo-ref` — model oparty na zdjęciu,
- `tested` — wydrukowany i sprawdzony,
- `unknown` — brak danych.

| Numer | Typ | Status | Profil | OpenSCAD | Uwagi |
|---:|---|---|---|---|---|
| 13 | single | source/profile/draft | `models/generated/cam_13_profile.json` | `models/generated/cam_13.scad` | model bazowy znany |
| 16 | single | source/profile/draft | `models/generated/cam_16_profile.json` | `models/generated/cam_16.scad` | model bazowy znany |
| 20 | single | source/profile/draft | `models/generated/cam_20_profile.json` | `models/generated/cam_20.scad` | model bazowy znany |
| 33 | single | source/profile/draft | `models/generated/cam_33_profile.json` | `models/generated/cam_33.scad` | model bazowy znany |
| 107 | double | source | — | do importu | model bazowy znany |
| pozostałe | single/double | unknown | — | — | do odtworzenia ze zdjęć i pomiarów |

## Priorytet najbliższych prac

1. Zaimportować pliki bazowe do `models/original/`.
2. Wyrenderować `cam_13.scad`, `cam_16.scad`, `cam_20.scad`, `cam_33.scad`.
3. Znaleźć zdjęcia dysków z czytelnymi numerami.
4. Dla każdego nowego numeru dodać `cam_XX_source.md` i `cam_XX_profile.json`.
