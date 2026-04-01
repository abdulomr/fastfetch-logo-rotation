#!/bin/bash
# install-fastfetch-rotation.sh
# Universal install script for fastfetch image rotation system

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current user's home directory
USER_HOME="$HOME"
CONFIG_DIR="$USER_HOME/.config/fastfetch"
FISH_CONFIG="$USER_HOME/.config/fish/config.fish"
FISH_FUNCTIONS="$USER_HOME/.config/fish/functions"

# Default settings (can be overridden by user)
ASPECT_WIDTH=1
ASPECT_HEIGHT=1
IMAGE_WIDTH=600
LOGO_HEIGHT=15
LOGO_WIDTH=15
SIXEL_TYPE="sixel"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --aspect)
            ASPECT_WIDTH=$(echo $2 | cut -d: -f1)
            ASPECT_HEIGHT=$(echo $2 | cut -d: -f2)
            shift 2
            ;;
        --width)
            IMAGE_WIDTH=$2
            shift 2
            ;;
        --logo-height)
            LOGO_HEIGHT=$2
            shift 2
            ;;
        --logo-width)
            LOGO_WIDTH=$2
            shift 2
            ;;
        --image-type)
            SIXEL_TYPE=$2
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --aspect W:H         Aspect ratio for cropping (default: 1:1)"
            echo "  --width N            Max width in pixels (default: 600)"
            echo "  --logo-height N      Fastfetch logo height (default: 15)"
            echo "  --logo-width N       Fastfetch logo width (default: 15)"
            echo "  --image-type TYPE    Image type (sixel, kitty, iterm2, auto) (default: sixel)"
            echo "  --help               Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage"
            exit 1
            ;;
    esac
done

# Welcome message
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Fastfetch Image Rotation Installer   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Installing for user: $(whoami)${NC}"
echo -e "${BLUE}Home directory: $USER_HOME${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}[1/6] Checking prerequisites...${NC}"

# Check if fastfetch is installed
if ! command -v fastfetch &> /dev/null; then
    echo -e "${RED}✗ fastfetch is not installed${NC}"
    echo ""
    echo "Please install fastfetch first:"
    echo "  Arch Linux:     sudo pacman -S fastfetch"
    echo "  Debian/Ubuntu:  sudo apt install fastfetch"
    echo "  Fedora:         sudo dnf install fastfetch"
    echo "  macOS:          brew install fastfetch"
    echo "  Or from source: https://github.com/fastfetch-cli/fastfetch"
    exit 1
fi
echo -e "${GREEN}✓ fastfetch $(fastfetch --version | head -1)${NC}"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${RED}✗ ImageMagick is not installed${NC}"
    echo ""
    echo "Please install ImageMagick first:"
    echo "  Arch Linux:     sudo pacman -S imagemagick"
    echo "  Debian/Ubuntu:  sudo apt install imagemagick"
    echo "  Fedora:         sudo dnf install ImageMagick"
    echo "  macOS:          brew install imagemagick"
    exit 1
fi
echo -e "${GREEN}✓ ImageMagick $(convert -version | head -1 | cut -d' ' -f3)${NC}"

# Check if Fish shell is installed
if ! command -v fish &> /dev/null; then
    echo -e "${RED}✗ Fish shell is not installed${NC}"
    echo ""
    echo "Please install Fish shell first:"
    echo "  Arch Linux:     sudo pacman -S fish"
    echo "  Debian/Ubuntu:  sudo apt install fish"
    echo "  Fedora:         sudo dnf install fish"
    echo "  macOS:          brew install fish"
    exit 1
fi
echo -e "${GREEN}✓ Fish shell $(fish --version | cut -d' ' -f3)${NC}"

# Check terminal sixel support (optional)
echo -e "${YELLOW}  (Optional) Checking terminal sixel support...${NC}"
if [[ "$TERM" == "foot" ]] || [[ "$TERM" == "xterm"* ]] || [[ "$TERM" == "kitty" ]]; then
    echo -e "${GREEN}  ✓ Terminal $TERM likely supports images${NC}"
else
    echo -e "${YELLOW}  ⚠ Terminal $TERM may not support images${NC}"
    echo "    For best results, use Foot, Kitty, or a terminal with sixel support"
fi

echo ""
echo -e "${YELLOW}[2/6] Creating directories...${NC}"

# Create directories
mkdir -p "$CONFIG_DIR/images"
mkdir -p "$CONFIG_DIR/cropped"
mkdir -p "$FISH_FUNCTIONS"

echo -e "${GREEN}✓ Created: $CONFIG_DIR${NC}"
echo -e "${GREEN}✓ Created: $CONFIG_DIR/images${NC}"
echo -e "${GREEN}✓ Created: $CONFIG_DIR/cropped${NC}"
echo -e "${GREEN}✓ Created: $FISH_FUNCTIONS${NC}"

echo ""
echo -e "${YELLOW}[3/6] Installing fastfetch configuration...${NC}"

# Create fastfetch config with user's home directory
cat > "$CONFIG_DIR/config.jsonc" << EOF
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "source": "$CONFIG_DIR/current-image.jpg",
        "type": "$SIXEL_TYPE",
        "height": $LOGO_HEIGHT,
        "width": $LOGO_WIDTH,
        "padding": {
            "top": 0,
            "left": 3
        }
    },
    "display": {
        "separator": "  ",
        "color": "white",
        "constants": ["\\u001b[37m", "\\u001b[38;5;16m", "\\u001b[38;5;17m", "\\u001b[38;5;18m"]
    },
    "modules": [
        "break",
        {
            "type": "custom",
            "key": "╭───────────────────────────────────╮"
        },
        {
            "type": "kernel",
            "key": "│ {\$2}{\$1}  kernel",
            "format": "{\$2}{release>22}{\$1} │"
        },
        {
            "type": "command",
            "key": "│   uptime",
            "text": "uptime -p | cut -d ' ' -f 2-",
            "format": "{>22} │"
        },
        {
            "type": "shell",
            "key": "│ {\$2}{\$1}  shell ",
            "format": "{\$2}{pretty-name>22}{\$1} │"
        },
        {
            "type": "command",
            "key": "│ {\$3}{\$1}  mem   ",
            "text": "free -m | awk 'NR==2{printf \"%.2f GiB / %.2f GiB\",\$3/1024,\$2/1024}'",
            "format": "{\$3}{>22}{\$1} │"
        },
        {
            "type": "packages",
            "key": "│   pkgs  ",
            "format": "{all>22} │"
        },
        {
            "type": "command",
            "key": "│ {\$2}{\$1}  user  ",
            "text": "echo \$USER",
            "format": "{\$2}{>22}{\$1} │"
        },
        {
            "type": "command",
            "key": "│   hname ",
            "text": "hostnamectl hostname",
            "format": "{>22} │"
        },
        {
            "type": "os",
            "key": "│ {\$4}󰻀{\$1}  distro",
            "format": "{\$4}{pretty-name>22}{\$1} │"
        },
        {
            "type": "custom",
            "key": "╰───────────────────────────────────╯"
        },
        "break"
    ]
}
EOF

echo -e "${GREEN}✓ Fastfetch config created${NC}"

echo ""
echo -e "${YELLOW}[4/6] Installing crop script...${NC}"

# Create crop script
cat > "$CONFIG_DIR/crop-image.sh" << EOF
#!/bin/bash
# Crop script for fastfetch images
# Crops images to $ASPECT_WIDTH:$ASPECT_HEIGHT aspect ratio

INPUT_DIR="$CONFIG_DIR/images"
OUTPUT_DIR="$CONFIG_DIR/cropped"
mkdir -p "\$OUTPUT_DIR"

# Settings
MAX_WIDTH=$IMAGE_WIDTH
ASPECT_W=$ASPECT_WIDTH
ASPECT_H=$ASPECT_HEIGHT
QUALITY=90

echo "Processing images with aspect ratio \$ASPECT_W:\$ASPECT_H..."

for ext in png jpg jpeg gif; do
    for img in "\$INPUT_DIR"/*.\$ext; do
        if [ -f "\$img" ]; then
            filename=\$(basename "\$img")
            output="\$OUTPUT_DIR/\${filename%.*}.jpg"
            
            # Get original dimensions
            dimensions=\$(identify -format "%wx%h" "\$img" 2>/dev/null)
            if [ -z "\$dimensions" ]; then
                echo "✗ Failed to read: \$filename"
                continue
            fi
            
            width=\$(echo \$dimensions | cut -dx -f1)
            height=\$(echo \$dimensions | cut -dx -f2)
            
            # Calculate target dimensions
            target_height=\$((width * ASPECT_H / ASPECT_W))
            
            if [ \$target_height -le \$height ]; then
                offset_y=\$(((height - target_height) / 2))
                offset_x=0
                crop_geometry="\${width}x\${target_height}+\${offset_x}+\${offset_y}"
            else
                target_width=\$((height * ASPECT_W / ASPECT_H))
                offset_x=\$(((width - target_width) / 2))
                offset_y=0
                crop_geometry="\${target_width}x\${height}+\${offset_x}+\${offset_y}"
            fi
            
            # Crop and resize
            convert "\$img" -crop "\$crop_geometry" -resize "\${MAX_WIDTH}x" -quality \$QUALITY "\$output" 2>/dev/null
            
            if [ \$? -eq 0 ]; then
                echo "✓ Processed: \$filename"
            else
                echo "✗ Failed: \$filename"
            fi
        fi
    done
done

echo "Done! Processed images are in \$OUTPUT_DIR"
EOF

chmod +x "$CONFIG_DIR/crop-image.sh"
echo -e "${GREEN}✓ Crop script installed${NC}"

echo ""
echo -e "${YELLOW}[5/6] Installing rotate script...${NC}"

# Create rotate script
cat > "$CONFIG_DIR/rotate-images.sh" << EOF
#!/bin/bash
CONFIG_DIR="$CONFIG_DIR"
IMAGES_DIR="\$CONFIG_DIR/cropped"
STATE_FILE="\$CONFIG_DIR/image-index.txt"

# Get list of images
images=()
for ext in jpg png; do
    for img in "\$IMAGES_DIR"/*.\$ext; do
        if [ -f "\$img" ]; then
            images+=("\$img")
        fi
    done
done

if [ \${#images[@]} -eq 0 ]; then
    echo "No images found in \$IMAGES_DIR"
    exit 1
fi

# Read current index or start at 0
if [ -f "\$STATE_FILE" ]; then
    current_index=\$(cat "\$STATE_FILE")
else
    current_index=0
fi

# Calculate next index
next_index=\$(( (current_index + 1) % \${#images[@]} ))

# Get the next image
next_image="\${images[\$next_index]}"

# Create a unique filename with timestamp
timestamp=\$(date +%s)
unique_file="current-image-\$timestamp.jpg"
cp "\$next_image" "\$CONFIG_DIR/\$unique_file"

# Clean up old files - keep only the last 1
cd "\$CONFIG_DIR"
ls -t current-image-*.jpg 2>/dev/null | tail -n +2 | xargs -r rm

# Save the new index
echo "\$next_index" > "\$STATE_FILE"

# Output the filename
echo "\$CONFIG_DIR/\$unique_file"
EOF

chmod +x "$CONFIG_DIR/rotate-images.sh"
echo -e "${GREEN}✓ Rotate script installed${NC}"

echo ""
echo -e "${YELLOW}[6/6] Installing fish functions...${NC}"

# Backup existing config if needed
if [ -f "$FISH_CONFIG" ]; then
    if ! grep -q "Fastfetch image management functions" "$FISH_CONFIG" 2>/dev/null; then
        cp "$FISH_CONFIG" "$FISH_CONFIG.backup.$(date +%s)"
        echo -e "${GREEN}✓ Backup created: $FISH_CONFIG.backup.$(date +%s)${NC}"
    fi
fi

# Add functions to fish config
cat >> "$FISH_CONFIG" << 'EOF'

# Fastfetch image management functions
set -g CONFIG_DIR "$HOME/.config/fastfetch"

# Rotate to next image
function next-image
    set new_image (bash "$CONFIG_DIR/rotate-images.sh")
    
    if test -n "$new_image"
        for old in $CONFIG_DIR/current-image-*.jpg
            if test "$old" != "$new_image"
                rm -f "$old"
            end
        end
        sed -i "s|\"source\": \".*\"|\"source\": \"$new_image\"|" "$CONFIG_DIR/config.jsonc"
        clear
        fastfetch
    else
        echo "Failed to rotate image"
    end
end

# Random image
function random-image
    set images (find $CONFIG_DIR/cropped -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null)
    
    if test (count $images) -gt 0
        set random_img $images[(random 1 (count $images))]
        set timestamp (date +%s)
        set new_image "$CONFIG_DIR/current-image-$timestamp.jpg"
        cp "$random_img" "$new_image"
        
        for old in $CONFIG_DIR/current-image-*.jpg
            if test "$old" != "$new_image"
                rm -f "$old"
            end
        end
        
        sed -i "s|\"source\": \".*\"|\"source\": \"$new_image\"|" "$CONFIG_DIR/config.jsonc"
        clear
        fastfetch
    else
        echo "No images found"
    end
end

# List all available images
function list-images
    echo "Available images:"
    set images $CONFIG_DIR/cropped/*.{jpg,png}
    if test -n "$images"
        for img in $images
            echo "  "(basename $img)
        end
    else
        echo "  No images found"
    end
end

# Preview current image
function current-image
    set current (grep '"source"' $CONFIG_DIR/config.jsonc | sed 's/.*"source": "\(.*\)".*/\1/')
    if test -f "$current"
        echo "Current image: "(basename $current)
        identify "$current" 2>/dev/null | awk '{print "Dimensions:", $3, "Size:", $7/1024 "KB"}'
    else
        echo "No current image found"
    end
end

# Re-crop all images
function recrop-images
    bash "$CONFIG_DIR/crop-image.sh"
    echo "All images recropped!"
    echo 0 > "$CONFIG_DIR/image-index.txt"
    bash "$CONFIG_DIR/rotate-images.sh"
    clear
    fastfetch
end

# Add new image
function add-image
    if test -z "$argv[1]"
        echo "Usage: add-image <image-file> [custom-name]"
        return 1
    end
    if test -n "$argv[2]"
        cp "$argv[1]" "$CONFIG_DIR/images/$argv[2]"
        echo "Added: $argv[2]"
    else
        cp "$argv[1]" "$CONFIG_DIR/images/"
        echo "Added: "(basename "$argv[1]")
    end
    recrop-images
end

# Quick refresh
function refresh
    clear
    fastfetch
end
EOF

echo -e "${GREEN}✓ Fish functions installed${NC}"

echo ""
echo -e "${YELLOW}Creating fish greeting...${NC}"

# Create fish greeting for random image on startup
cat > "$FISH_FUNCTIONS/fish_greeting.fish" << 'EOF'
function fish_greeting
    random-image
end
EOF

echo -e "${GREEN}✓ Fish greeting created${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         Installation Complete!         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Configuration:${NC}"
echo "  Aspect ratio: $ASPECT_WIDTH:$ASPECT_HEIGHT"
echo "  Max image width: ${IMAGE_WIDTH}px"
echo "  Logo size: ${LOGO_HEIGHT}x${LOGO_WIDTH}"
echo "  Image type: $SIXEL_TYPE"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo "1. Add images to your collection:"
echo -e "   ${GREEN}cp /path/to/your/images/* ~/.config/fastfetch/images/${NC}"
echo ""
echo "2. Process your images:"
echo -e "   ${GREEN}recrop-images${NC}"
echo ""
echo "3. Test the rotation:"
echo -e "   ${GREEN}next-image${NC}"
echo -e "   ${GREEN}random-image${NC}"
echo ""
echo "4. Available commands:"
echo -e "   ${GREEN}next-image${NC}      - Switch to next image"
echo -e "   ${GREEN}random-image${NC}    - Switch to random image"
echo -e "   ${GREEN}list-images${NC}     - List all available images"
echo -e "   ${GREEN}current-image${NC}   - Show current image info"
echo -e "   ${GREEN}add-image${NC}       - Add new image (usage: add-image /path/to/image.jpg)"
echo -e "   ${GREEN}recrop-images${NC}   - Re-crop all images"
echo -e "   ${GREEN}refresh${NC}         - Refresh display"
echo ""
echo -e "${BLUE}Note:${NC} Open a new terminal to see the random image on startup!"
echo ""
echo -e "${GREEN}Enjoy your rotating wallpapers! 🎨${NC}"
