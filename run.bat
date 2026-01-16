@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title Schoolar Pay - Josoa Code

echo.
echo      ╔═══════════════════════════════════════════════════════════════╗
echo      ║                                                               ║
echo      ║           ██╗ ██████╗ ███████╗ ██████╗  █████╗                ║
echo      ║           ██║██╔═══██╗██╔════╝██╔═══██╗██╔══██╗               ║
echo      ║           ██║██║   ██║███████╗██║   ██║███████║               ║
echo      ║      ██   ██║██║   ██║╚════██║██║   ██║██╔══██║               ║
echo      ║      ╚█████╔╝╚██████╔╝███████║╚██████╔╝██║  ██║               ║
echo      ║       ╚════╝  ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝               ║
echo      ║                                                               ║
echo      ║              ██████╗ ██████╗ ██████╗ ███████╗                 ║
echo      ║             ██╔════╝██╔═══██╗██╔══██╗██╔════╝                 ║
echo      ║             ██║     ██║   ██║██║  ██║█████╗                   ║
echo      ║             ██║     ██║   ██║██║  ██║██╔══╝                   ║
echo      ║             ╚██████╗╚██████╔╝██████╔╝███████╗                 ║
echo      ║              ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝                 ║
echo      ║                                                               ║
echo      ║           ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━             ║
echo      ║                SCHOOLAR PAY - Lancement                       ║
echo      ║           ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━             ║
echo      ║                                                               ║
echo      ╚═══════════════════════════════════════════════════════════════╝
echo.

set MIN_VERSION=3.10.0

REM Verifier si Flutter est installe
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERREUR] Flutter n'est pas installe ou n'est pas dans le PATH
    echo.
    echo Pour installer Flutter:
    echo   1. Telechargez Flutter: https://flutter.dev/docs/get-started/install
    echo   2. Extrayez l'archive
    echo   3. Ajoutez flutter\bin a votre PATH
    echo.
    pause
    exit /b 1
)

REM Recuperer la version de Flutter
for /f "tokens=2" %%a in ('flutter --version 2^>nul ^| findstr /r "^Flutter"') do set FLUTTER_VERSION=%%a

echo [INFO] Flutter detecte: v%FLUTTER_VERSION%
echo [INFO] Version minimale requise: v%MIN_VERSION%
echo.

REM Comparer les versions (simplifie)
for /f "tokens=1,2,3 delims=." %%a in ("%FLUTTER_VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
    set PATCH=%%c
)

for /f "tokens=1,2,3 delims=." %%a in ("%MIN_VERSION%") do (
    set MIN_MAJOR=%%a
    set MIN_MINOR=%%b
    set MIN_PATCH=%%c
)

set VERSION_OK=0
if %MAJOR% gtr %MIN_MAJOR% set VERSION_OK=1
if %MAJOR% equ %MIN_MAJOR% if %MINOR% gtr %MIN_MINOR% set VERSION_OK=1
if %MAJOR% equ %MIN_MAJOR% if %MINOR% equ %MIN_MINOR% if %PATCH% geq %MIN_PATCH% set VERSION_OK=1

if %VERSION_OK%==0 (
    echo [ERREUR] Version de Flutter trop ancienne!
    echo.
    echo Votre version:    %FLUTTER_VERSION%
    echo Version requise:  %MIN_VERSION%+
    echo.
    echo Pour mettre a jour Flutter, executez:
    echo   flutter upgrade
    echo.
    echo Ou telechargez la derniere version:
    echo   https://flutter.dev/docs/get-started/install
    echo.
    pause
    exit /b 1
)

echo [OK] Version Flutter compatible
echo.

REM Se placer dans le bon repertoire
cd /d "%~dp0"

REM Installer les dependances si necessaire
if not exist ".dart_tool" (
    echo [INFO] Installation des dependances...
    flutter pub get
    if %ERRORLEVEL% neq 0 (
        echo [ERREUR] Echec de l'installation des dependances
        pause
        exit /b 1
    )
    echo.
)

echo Choisissez une option:
echo   1) Lancer sur appareil connecte (mobile/emulateur)
echo   2) Lancer sur Windows (desktop)
echo   3) Lancer sur Chrome (web)
echo   4) Afficher les appareils disponibles
echo   5) Quitter
echo.
set /p choice="Votre choix [1-5]: "

if "%choice%"=="1" (
    echo [INFO] Lancement sur appareil mobile/emulateur...
    flutter run
) else if "%choice%"=="2" (
    echo [INFO] Lancement sur Windows...
    flutter run -d windows
) else if "%choice%"=="3" (
    echo [INFO] Lancement sur Chrome...
    flutter run -d chrome
) else if "%choice%"=="4" (
    echo [INFO] Appareils disponibles:
    flutter devices
    pause
) else if "%choice%"=="5" (
    echo Au revoir!
    exit /b 0
) else (
    echo [ERREUR] Choix invalide
    pause
    exit /b 1
)

pause
