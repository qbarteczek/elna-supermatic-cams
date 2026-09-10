@echo off
chcp 65001 >nul
title Generator Krzywek Elna Supermatic
echo ============================================================
echo  Uruchamianie Studia Projektowania Krzywek Sciegowych...
echo  Elna Supermatic / Elna SU (3D Cam Studio)
echo ============================================================
echo.
echo Otwieranie aplikacji w domyslnej przegladarce...
if exist "%~dp0index.html" (
    start "" "%~dp0index.html"
) else (
    start "" "%~dp0tools\generator\index.html"
)
exit
