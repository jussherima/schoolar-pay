@echo off
chcp 65001 >nul
title Schoolar Pay - Lancement

echo ========================================
echo        SCHOOLAR PAY - Lancement
echo ========================================
echo.

REM Vérifier si Flutter est installé
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERREUR] Flutter n'est pas installe ou n'est pas dans le PATH
    echo Installez Flutter depuis: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo [INFO] Flutter detecte:
flutter --version
echo.

REM Se placer dans le bon répertoire
cd /d "%~dp0"

REM Installer les dépendances si nécessaire
if not exist ".dart_tool" (
    echo [INFO] Installation des dependances...
    flutter pub get
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
