#!/bin/bash

# Fastfetch Logo Rotation - Uninstaller
# Only removes files/directories created by this project
# Preserves all fastfetch default configurations

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters for reporting
DELETED_DIRS=0
DELETED_FILES=0

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Function to confirm action
confirm() {
    local prompt="$1"
    local response
    
    while true; do
        read -p "$(echo -e ${YELLOW}$prompt${NC})" -n 1 -r response
        echo
        case "$response" in
            [Yy])
                return 0
                ;;
            [Nn])
                return 1
                ;;
            *)
                echo "Please answer yes or no."
                ;;
        esac
    done
}

# Function to remove directory if it exists
remove_directory() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Removing:${NC} $description"
        echo "  Path: $dir"
        rm -rf "$dir"
        ((DELETED_DIRS++))
        echo -e "${GREEN}✓ Removed${NC}\n"
    fi
}

# Function to remove file if it exists
remove_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Removing:${NC} $description"
        echo "  Path: $file"
        rm -f "$file"
        ((DELETED_FILES++))
        echo -e "${GREEN}✓ Removed${NC}\n"
    fi
}

# Main uninstall function
main() {
    print_header "Fastfetch Logo Rotation - Uninstaller"
    
    echo -e "${YELLOW}This script will remove ONLY files created by fastfetch-logo-rotation:${NC}\n"
    echo "  • ~/.config/fastfetch/images/ (your image collection)"
    echo "  • ~/.config/fastfetch/cropped/ (processed images)"
    echo "  • ~/.config/fastfetch/crop-image.sh (our script)"
    echo "  • ~/.config/fastfetch/rotate-images.sh (our script)"
    echo "  • ~/.config/fastfetch/image-index.txt (our file)"
    echo "  • ~/.config/fastfetch/current-image-*.jpg (cached images)"
    echo "  • ~/.config/fish/functions/fish_greeting.fish (our function)"
    echo ""
    echo -e "${GREEN}✓ Will NOT remove:${NC}"
    echo "  • ~/.config/fastfetch/config.jsonc (fastfetch config)"
    echo "  • Other fastfetch files or directories"
    echo "  • Your shell configs (.bashrc, .zshrc, config.fish)"
    echo "  • Any other configurations or data"
    echo ""
    
    if ! confirm "Do you want to continue? (y/n) "; then
        echo -e "${YELLOW}Uninstall cancelled.${NC}"
        exit 0
    fi
    
    print_header "Step 1: Removing Image Directories"
    
    # Remove only our project's image directories
    remove_directory "$HOME/.config/fastfetch/images" "Image collection directory"
    remove_directory "$HOME/.config/fastfetch/cropped" "Processed images directory"
    
    print_header "Step 2: Removing Project Scripts"
    
    # Remove only our specific scripts
    remove_file "$HOME/.config/fastfetch/crop-image.sh" "Image cropping script"
    remove_file "$HOME/.config/fastfetch/rotate-images.sh" "Image rotation script"
    remove_file "$HOME/.config/fastfetch/image-index.txt" "Image index file"
    
    print_header "Step 3: Removing Cached Images"
    
    # Remove timestamped cache files created by our rotation system
    if ls "$HOME/.config/fastfetch"/current-image-*.jpg &>/dev/null 2>&1; then
        echo -e "${YELLOW}Removing:${NC} Cached image files"
        rm -f "$HOME/.config/fastfetch"/current-image-*.jpg
        ((DELETED_FILES++))
        echo -e "${GREEN}✓ Removed${NC}\n"
    fi
    
    print_header "Step 4: Removing Fish Shell Function"
    
    # Remove only our fish greeting function
    remove_file "$HOME/.config/fish/functions/fish_greeting.fish" "Fish greeting function (our project)"
    
    print_header "Summary"
    
    echo -e "${GREEN}Uninstall complete!${NC}\n"
    echo "Removed:"
    echo -e "  • Directories: ${GREEN}$DELETED_DIRS${NC}"
    echo -e "  • Files: ${GREEN}$DELETED_FILES${NC}"
    echo ""
    
    if [ $DELETED_DIRS -eq 0 ] && [ $DELETED_FILES -eq 0 ]; then
        echo -e "${YELLOW}Note: Nothing was removed. The project files may not exist.${NC}"
    else
        echo -e "${GREEN}Fastfetch logo rotation files successfully removed!${NC}"
        echo -e "${GREEN}Your fastfetch configuration and other data are preserved.${NC}"
    fi
    
    echo ""
}

# Safety check - don't run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run this script as root!${NC}"
    echo "Run: bash uninstall-fastfetch-rotation.sh"
    exit 1
fi

# Run main uninstall
main "$@"
