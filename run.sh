#!/bin/bash

# ===========================================
# Schoolar Pay - Script de lancement
# Compatible Linux et macOS
# ===========================================

echo "========================================"
echo "       SCHOOLAR PAY - Lancement        "
echo "========================================"
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Vérifier si Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Erreur: Flutter n'est pas installé ou n'est pas dans le PATH${NC}"
    echo "Installez Flutter depuis: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo -e "${BLUE}Flutter detecte:${NC}"
flutter --version
echo ""

# Se placer dans le bon répertoire
cd "$(dirname "$0")"

# Installer les dépendances si nécessaire
if [ ! -d ".dart_tool" ]; then
    echo -e "${BLUE}Installation des dependances...${NC}"
    flutter pub get
    echo ""
fi

# Détecter l'OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM="linux";;
    Darwin*)    PLATFORM="macos";;
    *)          PLATFORM="unknown";;
esac

echo -e "${GREEN}Plateforme detectee: ${PLATFORM}${NC}"
echo ""

# Menu de sélection
echo "Choisissez une option:"
echo "  1) Lancer sur appareil connecte (mobile/emulateur)"
echo "  2) Lancer sur ${PLATFORM} (desktop)"
echo "  3) Lancer sur Chrome (web)"
echo "  4) Afficher les appareils disponibles"
echo "  5) Quitter"
echo ""
read -p "Votre choix [1-5]: " choice

case $choice in
    1)
        echo -e "${BLUE}Lancement sur appareil mobile/emulateur...${NC}"
        flutter run
        ;;
    2)
        echo -e "${BLUE}Lancement sur ${PLATFORM}...${NC}"
        flutter run -d ${PLATFORM}
        ;;
    3)
        echo -e "${BLUE}Lancement sur Chrome...${NC}"
        flutter run -d chrome
        ;;
    4)
        echo -e "${BLUE}Appareils disponibles:${NC}"
        flutter devices
        ;;
    5)
        echo "Au revoir!"
        exit 0
        ;;
    *)
        echo -e "${RED}Choix invalide${NC}"
        exit 1
        ;;
esac
