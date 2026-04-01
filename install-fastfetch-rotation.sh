#!/bin/bash

# Fastfetch Configuration Installer
# Auto-generated - DO NOT EDIT MANUALLY

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installing Fastfetch configuration...${NC}"

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# Install fastfetch if not present
install_fastfetch() {
    if command -v fastfetch &> /dev/null; then
        echo -e "${GREEN}✓ Fastfetch already installed${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Installing fastfetch...${NC}"
    OS=$(detect_os)
    
    case "$OS" in
        ubuntu|debian)
            sudo apt update && sudo apt install -y fastfetch
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm fastfetch
            ;;
        fedora)
            sudo dnf install -y fastfetch
            ;;
        *)
            echo -e "${RED}Unsupported OS. Please install fastfetch manually.${NC}"
            echo "Visit: https://github.com/fastfetch-cli/fastfetch"
            exit 1
            ;;
    esac
}

# Install fish shell if needed
install_fish() {
    if [ -d "$HOME/.config/fish" ] || [ -f "$HOME/.config/fish/config.fish" ]; then
        if ! command -v fish &> /dev/null; then
            echo -e "${YELLOW}Installing fish shell...${NC}"
            OS=$(detect_os)
            case "$OS" in
                ubuntu|debian)
                    sudo apt update && sudo apt install -y fish
                    ;;
                arch|manjaro)
                    sudo pacman -S --noconfirm fish
                    ;;
                fedora)
                    sudo dnf install -y fish
                    ;;
                *)
                    echo -e "${YELLOW}Fish shell not installed. Please install manually.${NC}"
                    ;;
            esac
        else
            echo -e "${GREEN}✓ Fish shell already installed${NC}"
        fi
    fi
}

# Write file from base64 encoded content
write_file() {
    local filepath="$1"
    local content_b64="$2"
    local mode="${3:-644}"
    
    mkdir -p "$(dirname "$filepath")"
    echo "$content_b64" | base64 -d > "$filepath"
    chmod "$mode" "$filepath"
    echo -e "${GREEN}✓ Created: $filepath${NC}"
}

# Main installation
main() {
    echo -e "${YELLOW}Writing configuration files...${NC}"
    
    # File: .config/fastfetch/config.jsonc
    write_file "$HOME/.config/fastfetch/config.jsonc" "ewogICAgIiRzY2hlbWEiOiAiaHR0cHM6Ly9naXRodWIuY29tL2Zhc3RmZXRjaC1jbGkvZmFzdGZldGNoL3Jhdy9kZXYvZG9jL2pzb25fc2NoZW1hLmpzb24iLAogICAgImxvZ28iOiB7CiAgICAgICAgInNvdXJjZSI6ICIvaG9tZS9hYmR1bHJhaG1hbi8uY29uZmlnL2Zhc3RmZXRjaC9jdXJyZW50LWltYWdlLTE3NzUwNjQzNDMuanBnIiwKICAgICAgICAidHlwZSI6ICJzaXhlbCIsCiAgICAgICAgImhlaWdodCI6IDE1LAogICAgICAgICJwYWRkaW5nIjogewogICAgICAgICAgICAidG9wIjogMiwKICAgICAgICAgICAgImxlZnQiOiAzCiAgICAgICAgfQogICAgfSwKICAgICJkaXNwbGF5IjogewogICAgICAgICJzZXBhcmF0b3IiOiAiICAiLAogICAgICAgICJjb2xvciI6ICJ3aGl0ZSIsCiAgICAgICAgImNvbnN0YW50cyI6IFsiXHUwMDFiWzM3bSIsICJcdTAwMWJbMzg7NTsxNm0iLCAiXHUwMDFiWzM4OzU7MTdtIiwgIlx1MDAxYlszODs1OzE4bSJdCiAgICB9LAogICAgIm1vZHVsZXMiOiBbCiAgICAgICAgImJyZWFrIiwKICAgICAgICB7CiAgICAgICAgICAgICJ0eXBlIjogImN1c3RvbSIsCiAgICAgICAgICAgICJrZXkiOiAi4pWt4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pWuIgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgICAidHlwZSI6ICJrZXJuZWwiLAogICAgICAgICAgICAia2V5IjogIuKUgiB7JDJ975GzeyQxfSAga2VybmVsIiwKICAgICAgICAgICAgImZvcm1hdCI6ICJ7JDJ9e3JlbGVhc2U+MjJ9eyQxfSDilIIiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJ0eXBlIjogImNvbW1hbmQiLAogICAgICAgICAgICAia2V5IjogIuKUgiDujoUgIHVwdGltZSIsCiAgICAgICAgICAgICJ0ZXh0IjogInVwdGltZSAtcCB8IGN1dCAtZCAnICcgLWYgMi0iLAogICAgICAgICAgICAiZm9ybWF0IjogIns+MjJ9IOKUgiIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgInR5cGUiOiAic2hlbGwiLAogICAgICAgICAgICAia2V5IjogIuKUgiB7JDJ975KJeyQxfSAgc2hlbGwgIiwKICAgICAgICAgICAgImZvcm1hdCI6ICJ7JDJ9e3ByZXR0eS1uYW1lPjIyfXskMX0g4pSCIgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgICAidHlwZSI6ICJjb21tYW5kIiwKICAgICAgICAgICAgImtleSI6ICLilIIgeyQzfe6/hXskMX0gIG1lbSAgICIsCiAgICAgICAgICAgICJ0ZXh0IjogImZyZWUgLW0gfCBhd2sgJ05SPT0ye3ByaW50ZiBcIiUuMmYgR2lCIC8gJS4yZiBHaUJcIiwkMy8xMDI0LCQyLzEwMjR9JyIsCiAgICAgICAgICAgICJmb3JtYXQiOiAieyQzfXs+MjJ9eyQxfSDilIIiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJ0eXBlIjogInBhY2thZ2VzIiwKICAgICAgICAgICAgImtleSI6ICLilIIg75KHICBwa2dzICAiLAogICAgICAgICAgICAiZm9ybWF0IjogInthbGw+MjJ9IOKUgiIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgInR5cGUiOiAiY29tbWFuZCIsCiAgICAgICAgICAgICJrZXkiOiAi4pSCIHskMn3vgId7JDF9ICB1c2VyICAiLAogICAgICAgICAgICAidGV4dCI6ICJlY2hvICRVU0VSIiwKICAgICAgICAgICAgImZvcm1hdCI6ICJ7JDJ9ez4yMn17JDF9IOKUgiIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgInR5cGUiOiAiY29tbWFuZCIsCiAgICAgICAgICAgICJrZXkiOiAi4pSCIO+EiCAgaG5hbWUgIiwKICAgICAgICAgICAgInRleHQiOiAiaG9zdG5hbWVjdGwgaG9zdG5hbWUiLAogICAgICAgICAgICAiZm9ybWF0IjogIns+MjJ9IOKUgiIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgInR5cGUiOiAib3MiLAogICAgICAgICAgICAia2V5IjogIuKUgiB7JDR987C7gHskMX0gIGRpc3RybyIsCiAgICAgICAgICAgICJmb3JtYXQiOiAieyQ0fXtwcmV0dHktbmFtZT4yMn17JDF9IOKUgiIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgInR5cGUiOiAiY3VzdG9tIiwKICAgICAgICAgICAgImtleSI6ICLilbDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDila8iCiAgICAgICAgfSwKICAgICAgICAiYnJlYWsiCiAgICBdCn0K" 644
    
    # File: .config/fastfetch/crop-image.sh
    write_file "$HOME/.config/fastfetch/crop-image.sh" "IyEvYmluL2Jhc2gKSU5QVVRfRElSPSIvaG9tZS9hYmR1bHJhaG1hbi8uY29uZmlnL2Zhc3RmZXRjaC9pbWFnZXMiCk9VVFBVVF9ESVI9Ii9ob21lL2FiZHVscmFobWFuLy5jb25maWcvZmFzdGZldGNoL2Nyb3BwZWQiCm1rZGlyIC1wICIkT1VUUFVUX0RJUiIKCiMgU2V0dGluZ3MKTUFYX1dJRFRIPTYwMApBU1BFQ1RfVz0xCkFTUEVDVF9IPTEKUVVBTElUWT05MApST1VOREVEPWZhbHNlCkNPUk5FUl9SQURJVVM9MzAKCmVjaG8gIlByb2Nlc3NpbmcgaW1hZ2VzIHdpdGggYXNwZWN0IHJhdGlvICRBU1BFQ1RfVzokQVNQRUNUX0guLi4iCgojIENsZWFuIG9sZCBjcm9wcGVkIGltYWdlcwplY2hvICJDbGVhbmluZyBvbGQgY3JvcHBlZCBpbWFnZXMuLi4iCnJtIC1mICIkT1VUUFVUX0RJUiIvKi57anBnLHBuZ30KZWNobyAi4pyTIE9sZCBpbWFnZXMgcmVtb3ZlZCIKCiMgQ291bnQgcHJvY2Vzc2VkIGltYWdlcwpjb3VudD0wCgpmb3IgZXh0IGluIHBuZyBqcGcganBlZyBnaWY7IGRvCiAgICBmb3IgaW1nIGluICIkSU5QVVRfRElSIi8qLiRleHQ7IGRvCiAgICAgICAgaWYgWyAtZiAiJGltZyIgXTsgdGhlbgogICAgICAgICAgICBmaWxlbmFtZT0kKGJhc2VuYW1lICIkaW1nIikKICAgICAgICAgICAgb3V0cHV0PSIkT1VUUFVUX0RJUi8ke2ZpbGVuYW1lJS4qfS5qcGciCiAgICAgICAgICAgIAogICAgICAgICAgICAjIEdldCBvcmlnaW5hbCBkaW1lbnNpb25zCiAgICAgICAgICAgIGRpbWVuc2lvbnM9JChpZGVudGlmeSAtZm9ybWF0ICIld3glaCIgIiRpbWciIDI+L2Rldi9udWxsKQogICAgICAgICAgICBpZiBbIC16ICIkZGltZW5zaW9ucyIgXTsgdGhlbgogICAgICAgICAgICAgICAgZWNobyAi4pyXIEZhaWxlZCB0byByZWFkOiAkZmlsZW5hbWUiCiAgICAgICAgICAgICAgICBjb250aW51ZQogICAgICAgICAgICBmaQogICAgICAgICAgICAKICAgICAgICAgICAgd2lkdGg9JChlY2hvICRkaW1lbnNpb25zIHwgY3V0IC1keCAtZjEpCiAgICAgICAgICAgIGhlaWdodD0kKGVjaG8gJGRpbWVuc2lvbnMgfCBjdXQgLWR4IC1mMikKICAgICAgICAgICAgCiAgICAgICAgICAgICMgQ2FsY3VsYXRlIHRhcmdldCBkaW1lbnNpb25zCiAgICAgICAgICAgIHRhcmdldF9oZWlnaHQ9JCgod2lkdGggKiBBU1BFQ1RfSCAvIEFTUEVDVF9XKSkKICAgICAgICAgICAgCiAgICAgICAgICAgIGlmIFsgJHRhcmdldF9oZWlnaHQgLWxlICRoZWlnaHQgXTsgdGhlbgogICAgICAgICAgICAgICAgb2Zmc2V0X3k9JCgoKGhlaWdodCAtIHRhcmdldF9oZWlnaHQpIC8gMikpCiAgICAgICAgICAgICAgICBvZmZzZXRfeD0wCiAgICAgICAgICAgICAgICBjcm9wX2dlb21ldHJ5PSIke3dpZHRofXgke3RhcmdldF9oZWlnaHR9KyR7b2Zmc2V0X3h9KyR7b2Zmc2V0X3l9IgogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICB0YXJnZXRfd2lkdGg9JCgoaGVpZ2h0ICogQVNQRUNUX1cgLyBBU1BFQ1RfSCkpCiAgICAgICAgICAgICAgICBvZmZzZXRfeD0kKCgod2lkdGggLSB0YXJnZXRfd2lkdGgpIC8gMikpCiAgICAgICAgICAgICAgICBvZmZzZXRfeT0wCiAgICAgICAgICAgICAgICBjcm9wX2dlb21ldHJ5PSIke3RhcmdldF93aWR0aH14JHtoZWlnaHR9KyR7b2Zmc2V0X3h9KyR7b2Zmc2V0X3l9IgogICAgICAgICAgICBmaQogICAgICAgICAgICAKICAgICAgICAgICAgIyBDcm9wIGFuZCByZXNpemUKICAgICAgICAgICAgY29udmVydCAiJGltZyIgLWNyb3AgIiRjcm9wX2dlb21ldHJ5IiAtcmVzaXplICIke01BWF9XSURUSH14IiAtcXVhbGl0eSAkUVVBTElUWSAiJG91dHB1dCIgMj4vZGV2L251bGwKICAgICAgICAgICAgCiAgICAgICAgICAgIGlmIFsgJD8gLWVxIDAgXTsgdGhlbgogICAgICAgICAgICAgICAgZWNobyAi4pyTIFByb2Nlc3NlZDogJGZpbGVuYW1lIgogICAgICAgICAgICAgICAgKChjb3VudCsrKSkKICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgZWNobyAi4pyXIEZhaWxlZDogJGZpbGVuYW1lIgogICAgICAgICAgICBmaQogICAgICAgIGZpCiAgICBkb25lCmRvbmUKCgppZiBbICRjb3VudCAtZXEgMCBdOyB0aGVuCiAgICBlY2hvICLimqAgTm8gaW1hZ2VzIGZvdW5kIGluICRJTlBVVF9ESVIiCiAgICBlY2hvICIgIEFkZCBpbWFnZXMgdG86ICRJTlBVVF9ESVIiCmVsc2UKICAgIGVjaG8gIkRvbmUhIFByb2Nlc3NlZCAkY291bnQgaW1hZ2VzIHRvICRPVVRQVVRfRElSIgpmaQo=" 755
    
    # File: .config/fastfetch/rotate-images.sh
    write_file "$HOME/.config/fastfetch/rotate-images.sh" "IyEvYmluL2Jhc2gKQ09ORklHX0RJUj0iL2hvbWUvYWJkdWxyYWhtYW4vLmNvbmZpZy9mYXN0ZmV0Y2giCklNQUdFU19ESVI9IiRDT05GSUdfRElSL2Nyb3BwZWQiClNUQVRFX0ZJTEU9IiRDT05GSUdfRElSL2ltYWdlLWluZGV4LnR4dCIKVEFSR0VUX0ZJTEU9IiRDT05GSUdfRElSL2N1cnJlbnQtaW1hZ2UuanBnIgpDQUNIRV9ESVI9IiRIT01FLy5jYWNoZS9mYXN0ZmV0Y2giCgojIEdldCBsaXN0IG9mIGltYWdlcwppbWFnZXM9KCkKZm9yIGV4dCBpbiBqcGcgcG5nOyBkbwogICAgZm9yIGltZyBpbiAiJElNQUdFU19ESVIiLyouJGV4dDsgZG8KICAgICAgICBpZiBbIC1mICIkaW1nIiBdOyB0aGVuCiAgICAgICAgICAgIGltYWdlcys9KCIkaW1nIikKICAgICAgICBmaQogICAgZG9uZQpkb25lCgppZiBbICR7I2ltYWdlc1tAXX0gLWVxIDAgXTsgdGhlbgogICAgZWNobyAiTm8gaW1hZ2VzIGZvdW5kIGluICRJTUFHRVNfRElSIgogICAgZXhpdCAxCmZpCgojIFJlYWQgY3VycmVudCBpbmRleCBvciBzdGFydCBhdCAwCmlmIFsgLWYgIiRTVEFURV9GSUxFIiBdOyB0aGVuCiAgICBjdXJyZW50X2luZGV4PSQoY2F0ICIkU1RBVEVfRklMRSIpCmVsc2UKICAgIGN1cnJlbnRfaW5kZXg9MApmaQoKIyBDYWxjdWxhdGUgbmV4dCBpbmRleApuZXh0X2luZGV4PSQoKCAoY3VycmVudF9pbmRleCArIDEpICUgJHsjaW1hZ2VzW0BdfSApKQoKIyBHZXQgdGhlIG5leHQgaW1hZ2UKbmV4dF9pbWFnZT0iJHtpbWFnZXNbJG5leHRfaW5kZXhdfSIKCiMgQ29weSB0byB0YXJnZXQgZmlsZSAob3ZlcndyaXRlKQpjcCAiJG5leHRfaW1hZ2UiICIkVEFSR0VUX0ZJTEUiCgojIENsZWFyIGZhc3RmZXRjaCBjYWNoZQpybSAtcmYgIiRDQUNIRV9ESVIiCgojIFNhdmUgdGhlIG5ldyBpbmRleAplY2hvICIkbmV4dF9pbmRleCIgPiAiJFNUQVRFX0ZJTEUiCgojIE91dHB1dCB0aGUgZmlsZW5hbWUKZWNobyAiJFRBUkdFVF9GSUxFIgo=" 755
    
    # File: .config/fish/config.fish
    write_file "$HOME/.config/fish/config.fish" "aWYgc3RhdHVzIGlzLWludGVyYWN0aXZlCiAgICAjIFN0YXJzaGlwIGN1c3RvbSBwcm9tcHQKICAgIHN0YXJzaGlwIGluaXQgZmlzaCB8IHNvdXJjZQoKICAgICMgRGlyZW52ICsgWm94aWRlCiAgICBjb21tYW5kIC12IGRpcmVudiAmPi9kZXYvbnVsbCAmJiBkaXJlbnYgaG9vayBmaXNoIHwgc291cmNlCiAgICBjb21tYW5kIC12IHpveGlkZSAmPi9kZXYvbnVsbCAmJiB6b3hpZGUgaW5pdCBmaXNoIC0tY21kIGNkIHwgc291cmNlCgogICAgIyBCZXR0ZXIgbHMKICAgIGFsaWFzIGxzPSdlemEgLS1pY29ucyAtLWdyb3VwLWRpcmVjdG9yaWVzLWZpcnN0IC0xJwoKICAgICMgQWJicnMKICAgIGFiYnIgbGcgbGF6eWdpdAogICAgYWJiciBnZCAnZ2l0IGRpZmYnCiAgICBhYmJyIGdhICdnaXQgYWRkIC4nCiAgICBhYmJyIGdjICdnaXQgY29tbWl0IC1hbScKICAgIGFiYnIgZ2wgJ2dpdCBsb2cnCiAgICBhYmJyIGdzICdnaXQgc3RhdHVzJwogICAgYWJiciBnc3QgJ2dpdCBzdGFzaCcKICAgIGFiYnIgZ3NwICdnaXQgc3Rhc2ggcG9wJwogICAgYWJiciBncCAnZ2l0IHB1c2gnCiAgICBhYmJyIGdwbCAnZ2l0IHB1bGwnCiAgICBhYmJyIGdzdyAnZ2l0IHN3aXRjaCcKICAgIGFiYnIgZ3NtICdnaXQgc3dpdGNoIG1haW4nCiAgICBhYmJyIGdiICdnaXQgYnJhbmNoJwogICAgYWJiciBnYmQgJ2dpdCBicmFuY2ggLWQnCiAgICBhYmJyIGdjbyAnZ2l0IGNoZWNrb3V0JwogICAgYWJiciBnc2ggJ2dpdCBzaG93JwoKICAgIGFiYnIgbCBscwogICAgYWJiciBsbCAnbHMgLWwnCiAgICBhYmJyIGxhICdscyAtYScKICAgIGFiYnIgbGxhICdscyAtbGEnCgogICAgIyBDdXN0b20gY29sb3VycwogICAgY2F0IH4vLmxvY2FsL3N0YXRlL2NhZWxlc3RpYS9zZXF1ZW5jZXMudHh0IDI+L2Rldi9udWxsCgogICAgIyBGb3IganVtcGluZyBiZXR3ZWVuIHByb21wdHMgaW4gZm9vdCB0ZXJtaW5hbAogICAgZnVuY3Rpb24gbWFya19wcm9tcHRfc3RhcnQgLS1vbi1ldmVudCBmaXNoX3Byb21wdAogICAgICAgIGVjaG8gLWVuICJcZV0xMzM7QVxlXFwiCiAgICBlbmQKCiAgICAjIEN1c3RvbSBmaXNoIGNvbmZpZwogICAgc291cmNlIH4vLmNvbmZpZy9jYWVsZXN0aWEvdXNlci1jb25maWcuZmlzaCAyPi9kZXYvbnVsbAplbmQKCiMgRmFzdGZldGNoIGNvbmZpZ3VyYXRpb24Kc2V0IC1nIENPTkZJR19ESVIgIiRIT01FLy5jb25maWcvZmFzdGZldGNoIgoKIyBTaW1wbGUgd3JhcHBlciBmdW5jdGlvbnMKCmZ1bmN0aW9uIG5leHQtaW1hZ2UKICAgICMgUnVuIHJvdGF0aW9uCiAgICBzZXQgbmV3X2ltYWdlIChiYXNoICIkQ09ORklHX0RJUi9yb3RhdGUtaW1hZ2VzLnNoIikKCiAgICAjIENsZWFyIGZhc3RmZXRjaCBjYWNoZQogICAgcm0gLXJmIH4vLmNhY2hlL2Zhc3RmZXRjaAoKICAgICMgU2hvdyBuZXcgaW1hZ2UKICAgIGNsZWFyCiAgICBmYXN0ZmV0Y2gKZW5kCgpmdW5jdGlvbiByYW5kb20taW1hZ2UKICAgIHNldCBpbWFnZXMgKGZpbmQgJENPTkZJR19ESVIvY3JvcHBlZCAtdHlwZSBmIFwoIC1uYW1lICIqLmpwZyIgLW8gLW5hbWUgIioucG5nIiBcKSAyPi9kZXYvbnVsbCkKICAgIGlmIHRlc3QgKGNvdW50ICRpbWFnZXMpIC1ndCAwCiAgICAgICAgc2V0IHJhbmRvbV9pbWcgJGltYWdlc1socmFuZG9tIDEgKGNvdW50ICRpbWFnZXMpKV0KICAgICAgICBzZXQgdGltZXN0YW1wIChkYXRlICslcykKICAgICAgICBzZXQgbmV3X2ltYWdlICIkQ09ORklHX0RJUi9jdXJyZW50LWltYWdlLSR0aW1lc3RhbXAuanBnIgogICAgICAgIGNwICIkcmFuZG9tX2ltZyIgIiRuZXdfaW1hZ2UiCiAgICAgICAgc2VkIC1pICJzfFwic291cmNlXCI6IFwiLipcInxcInNvdXJjZVwiOiBcIiRuZXdfaW1hZ2VcInwiICIkQ09ORklHX0RJUi9jb25maWcuanNvbmMiCgogICAgICAgICMgQ2xlYW4gdXAgb2xkIGZpbGVzIC0ga2VlcCBsYXN0IDEwCiAgICAgICAgZm9yIG9sZCBpbiAkQ09ORklHX0RJUi9jdXJyZW50LWltYWdlLSouanBnCiAgICAgICAgICAgIGlmIHRlc3QgIiRvbGQiICE9ICIkbmV3X2ltYWdlIgogICAgICAgICAgICAgICAgcm0gLWYgIiRvbGQiIDI+L2Rldi9udWxsCiAgICAgICAgICAgIGVuZAogICAgICAgIGVuZAoKICAgICAgICAjIENsZWFyIGNhY2hlIGFuZCBzaG93CiAgICAgICAgcm0gLXJmIH4vLmNhY2hlL2Zhc3RmZXRjaAogICAgICAgIGNsZWFyCiAgICAgICAgZmFzdGZldGNoCiAgICBlbHNlCiAgICAgICAgZWNobyAiTm8gaW1hZ2VzIGZvdW5kIgogICAgZW5kCmVuZAoKZnVuY3Rpb24gcmVjcm9wLWltYWdlcwogICAgIyBDbGVhbiBvbGQgY3VycmVudCBpbWFnZXMKICAgIHJtIC1mICRDT05GSUdfRElSL2N1cnJlbnQtaW1hZ2UtKi5qcGcKICAgIHJtIC1mICRDT05GSUdfRElSL2ltYWdlLWluZGV4LnR4dAogICAgcm0gLXJmIH4vLmNhY2hlL2Zhc3RmZXRjaAoKICAgICMgUnVuIGNyb3Agc2NyaXB0CiAgICBiYXNoICIkQ09ORklHX0RJUi9jcm9wLWltYWdlLnNoIgoKICAgICMgUmVzZXQgYW5kIHNob3cgZmlyc3QgaW1hZ2UKICAgIGVjaG8gMCA+IiRDT05GSUdfRElSL2ltYWdlLWluZGV4LnR4dCIKICAgIGJhc2ggIiRDT05GSUdfRElSL3JvdGF0ZS1pbWFnZXMuc2giCgogICAgY2xlYXIKICAgIGZhc3RmZXRjaAplbmQKCmZ1bmN0aW9uIHJlZnJlc2gKICAgIGNsZWFyCiAgICBmYXN0ZmV0Y2gKZW5kCgpmdW5jdGlvbiBsaXN0LWltYWdlcwogICAgZWNobyAiQXZhaWxhYmxlIGltYWdlczoiCiAgICBscyAtMSAiJENPTkZJR19ESVIvY3JvcHBlZCIvKi57anBnLHBuZ30gMj4vZGV2L251bGwgfCB4YXJncyAtbjEgYmFzZW5hbWUKZW5kCgpmdW5jdGlvbiBjdXJyZW50LWltYWdlCiAgICBpZiB0ZXN0IC1mICIkQ09ORklHX0RJUi9jdXJyZW50LWltYWdlLmpwZyIKICAgICAgICBlY2hvICJDdXJyZW50IGltYWdlOiAiKGJhc2VuYW1lICIkQ09ORklHX0RJUi9jdXJyZW50LWltYWdlLmpwZyIpCiAgICAgICAgaWRlbnRpZnkgIiRDT05GSUdfRElSL2N1cnJlbnQtaW1hZ2UuanBnIiAyPi9kZXYvbnVsbCB8IGF3ayAne3ByaW50ICJEaW1lbnNpb25zOiIsICQzLCAiU2l6ZToiLCAkNy8xMDI0ICJLQiJ9JwogICAgZWxzZQogICAgICAgIGVjaG8gIk5vIGN1cnJlbnQgaW1hZ2Ugc2V0IgogICAgZW5kCmVuZAoKZnVuY3Rpb24gY2xlYW4tYWxsCiAgICBlY2hvICJDbGVhbmluZyBhbGwgaW1hZ2VzLi4uIgogICAgcm0gLWYgJENPTkZJR19ESVIvY3JvcHBlZC8qLntqcGcscG5nfQogICAgcm0gLWYgJENPTkZJR19ESVIvaW1hZ2UtaW5kZXgudHh0CiAgICBybSAtZiAiJENPTkZJR19ESVIvY3VycmVudC1pbWFnZS5qcGciCiAgICBlY2hvICLinJMgQ2xlYW5lZCIKICAgIHJlY3JvcC1pbWFnZXMKZW5kCg==" 644
    
    # File: .config/fish/functions/fish_greeting.fish
    write_file "$HOME/.config/fish/functions/fish_greeting.fish" "ZnVuY3Rpb24gZmlzaF9ncmVldGluZwogICAgcmFuZG9tLWltYWdlCmVuZAo=" 644
    
    # Install dependencies
    install_fastfetch
    install_fish
    
    # Add alias
    add_alias() {
        local SHELL_CONFIG=""
        if [ -f "$HOME/.bashrc" ]; then
            SHELL_CONFIG="$HOME/.bashrc"
        elif [ -f "$HOME/.zshrc" ]; then
            SHELL_CONFIG="$HOME/.zshrc"
        elif [ -f "$HOME/.config/fish/config.fish" ]; then
            SHELL_CONFIG="$HOME/.config/fish/config.fish"
        fi
        
        if [ -n "$SHELL_CONFIG" ]; then
            if ! grep -q "alias ff=" "$SHELL_CONFIG" 2>/dev/null; then
                echo -e "${YELLOW}Adding alias to $SHELL_CONFIG...${NC}"
                if [[ "$SHELL_CONFIG" == *"fish"* ]]; then
                    echo 'alias ff="fastfetch"' >> "$SHELL_CONFIG"
                else
                    echo 'alias ff="fastfetch"' >> "$SHELL_CONFIG"
                fi
                echo -e "${GREEN}✓ Alias added${NC}"
                echo -e "Run: ${YELLOW}source $SHELL_CONFIG${NC} to apply"
            fi
        fi
    }
    
    add_alias
    
    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "Run with: ${YELLOW}fastfetch${NC} or ${YELLOW}ff${NC}"
    echo -e "\n${YELLOW}Available fish functions:${NC}"
    echo -e "  ${GREEN}next-image${NC}     - Rotate to next image"
    echo -e "  ${GREEN}random-image${NC}   - Show random image"
    echo -e "  ${GREEN}recrop-images${NC}  - Re-crop all images"
    echo -e "  ${GREEN}clean-all${NC}      - Clean and re-crop all images"
}

main "$@"
