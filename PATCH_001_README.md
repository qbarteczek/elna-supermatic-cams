# Patch 001 — profile-based workflow

Ten pakiet dodaje pierwszy realny workflow do odtwarzania krzywek Elna Supermatic:

1. poprawienie licencji repozytorium na GPL-3.0,
2. import modeli bazowych z projektu `ln-komandur/elna-cam-discs`,
3. format profilu 18-pozycyjnego,
4. generator plików OpenSCAD z profilu JSON,
5. narzędzie pomocnicze do wyciągania profilu ze zdjęcia.

## Co skopiować do repo

Skopiuj zawartość tej paczki do głównego katalogu repozytorium `elna-supermatic-cams`,
nadpisując istniejące pliki, jeśli GitHub zapyta.

## Proponowany commit

```bash
git add .
git commit -m "Add profile-based cam reconstruction workflow"
git push
```

## Ważne

Modele bazowe są na GPL-3.0, więc całe repozytorium też ustawiamy jako GPL-3.0.
Nie wrzucamy cudzych zdjęć bez licencji — w `references/` trzymamy linki, opis i własny obrys/profil.
