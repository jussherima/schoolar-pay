#!/bin/bash

# ===========================================
# Schoolar Pay - Script de lancement
# Compatible Linux et macOS
# Version minimale requise: Flutter 3.10.0
# ===========================================

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ASCII Art Banner
echo ""
echo -e "${CYAN}     ╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}     ║${NC}                                                               ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}      ${MAGENTA}     ██╗ ██████╗ ███████╗ ██████╗  █████╗${NC}            ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}      ${MAGENTA}     ██║██╔═══██╗██╔════╝██╔═══██╗██╔══██╗${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}      ${MAGENTA}     ██║██║   ██║███████╗██║   ██║███████║${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}      ${MAGENTA}██   ██║██║   ██║╚════██║██║   ██║██╔══██║${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}      ${MAGENTA}╚█████╔╝╚██████╔╝███████║╚██████╔╝██║  ██║${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}      ${MAGENTA} ╚════╝  ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}                                                               ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}            ${YELLOW} ██████╗ ██████╗ ██████╗ ███████╗${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}            ${YELLOW}██╔════╝██╔═══██╗██╔══██╗██╔════╝${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}            ${YELLOW}██║     ██║   ██║██║  ██║█████╗${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}            ${YELLOW}██║     ██║   ██║██║  ██║██╔══╝${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}            ${YELLOW}╚██████╗╚██████╔╝██████╔╝███████╗${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}            ${YELLOW} ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}                                                               ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}         ${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}            ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}              ${GREEN}🎓 SCHOOLAR PAY - Lancement 🎓${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}         ${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}            ${CYAN}║${NC}"
echo -e "${CYAN}     ║${NC}                                                               ${CYAN}║${NC}"
echo -e "${CYAN}     ╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

MIN_FLUTTER_VERSION="3.10.0"

# Fonction pour comparer les versions
version_compare() {
    local ver1=$1
    local ver2=$2

    IFS='.' read -ra V1 <<< "$ver1"
    IFS='.' read -ra V2 <<< "$ver2"

    for i in 0 1 2; do
        local v1=${V1[$i]:-0}
        local v2=${V2[$i]:-0}

        if [ "$v1" -lt "$v2" ]; then
            return 1  # ver1 < ver2
        elif [ "$v1" -gt "$v2" ]; then
            return 0  # ver1 > ver2
        fi
    done
    return 0  # ver1 == ver2
}

# Vérifier si Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}[ERREUR] Flutter n'est pas installe ou n'est pas dans le PATH${NC}"
    echo ""
    echo "Pour installer Flutter:"
    echo "  1. Telechargez Flutter: https://flutter.dev/docs/get-started/install"
    echo "  2. Extrayez l'archive"
    echo "  3. Ajoutez flutter/bin a votre PATH"
    echo ""
    exit 1
fi

# Récupérer la version de Flutter
FLUTTER_VERSION=$(flutter --version | head -n1 | sed 's/Flutter \([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')

echo -e "${BLUE}Flutter detecte: ${GREEN}v${FLUTTER_VERSION}${NC}"
echo -e "${BLUE}Version minimale requise: ${YELLOW}v${MIN_FLUTTER_VERSION}${NC}"
echo ""

# Vérifier la version
if ! version_compare "$FLUTTER_VERSION" "$MIN_FLUTTER_VERSION"; then
    echo -e "${RED}[ERREUR] Version de Flutter trop ancienne!${NC}"
    echo ""
    echo -e "Votre version:    ${RED}${FLUTTER_VERSION}${NC}"
    echo -e "Version requise:  ${GREEN}${MIN_FLUTTER_VERSION}+${NC}"
    echo ""
    echo "Pour mettre a jour Flutter, executez:"
    echo -e "  ${YELLOW}flutter upgrade${NC}"
    echo ""
    echo "Ou telechargez la derniere version:"
    echo "  https://flutter.dev/docs/get-started/install"
    echo ""
    exit 1
fi

echo -e "${GREEN}[OK] Version Flutter compatible${NC}"
echo ""

# Se placer dans le bon répertoire
cd "$(dirname "$0")"

# Installer les dépendances si nécessaire
if [ ! -d ".dart_tool" ] || [ ! -f "pubspec.lock" ]; then
    echo -e "${BLUE}Installation des dependances...${NC}"
    flutter pub get
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERREUR] Echec de l'installation des dependances${NC}"
        exit 1
    fi
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
echo -e "${WHITE}Choisissez une option:${NC}"
echo -e "  ${CYAN}1)${NC} Lancer sur appareil connecte (mobile/emulateur)"
echo -e "  ${CYAN}2)${NC} Lancer sur ${PLATFORM} (desktop)"
echo -e "  ${CYAN}3)${NC} Lancer sur Chrome (web)"
echo -e "  ${CYAN}4)${NC} Afficher les appareils disponibles"
echo -e "  ${CYAN}5)${NC} Quitter"
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
        echo -e "${GREEN}Au revoir! 👋${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Choix invalide${NC}"
        exit 1
        ;;
esac
