
```markdown
# Fastfetch Image Rotation System

A complete solution for rotating and randomizing images in fastfetch with automatic cropping, terminal cache bypass, and seamless Fish shell integration.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Fish Shell](https://img.shields.io/badge/shell-fish-blue.svg)](https://fishshell.com/)
[![Fastfetch](https://img.shields.io/badge/fastfetch-2.x-green.svg)](https://github.com/fastfetch-cli/fastfetch)

## ✨ Features

- 🔄 **Manual Image Rotation** - Switch between images with a simple command
- 🎲 **Random Image Selection** - Get a random image on demand or on terminal startup
- ✂️ **Smart Cropping** - Automatically crops images to your preferred aspect ratio
- 🚀 **Cache Bypass** - Unique timestamped filenames ensure fresh images every time
- 🎨 **Customizable** - Configurable aspect ratios, image sizes, and display dimensions
- 🐟 **Fish Shell Integration** - Clean wrapper functions for all operations
- 📦 **Standalone Installer** - Single self-contained script with all configs embedded

## 📋 Prerequisites

- **fastfetch** - System information tool with image support
- **ImageMagick** - Image processing (for cropping operations)
- **Fish Shell** - Modern shell with nice features (optional but recommended)
- **Terminal with image support** - Foot, Kitty, iTerm2, or any terminal with sixel/kitty graphics protocol

### Install Prerequisites

```bash
# Arch Linux
sudo pacman -S fastfetch imagemagick fish

# Debian/Ubuntu
sudo apt install fastfetch imagemagick fish

# Fedora
sudo dnf install fastfetch ImageMagick fish

# macOS
brew install fastfetch imagemagick fish
```

## 🚀 Quick Installation

### One-Command Install

```bash
# Clone or download the repository
git clone https://github.com/yourusername/fastfetch-rotation.git
cd fastfetch-rotation

# Generate the install script (if you have the source files)
./update.sh

# Or run the pre-generated install script directly
./install-fastfetch-rotation.sh
```

The install script is completely self-contained and will:
- Install required dependencies (fastfetch, fish, ImageMagick)
- Copy all configuration files to the correct locations
- Set up Fish shell functions
- Add a `ff` alias for fastfetch

## 📖 Usage

### Basic Commands

After installation, these Fish shell functions are available:

| Command | Description |
|---------|-------------|
| `next-image` | Rotate to the next image in your collection |
| `random-image` | Select and display a random image |
| `list-images` | Show all available cropped images |
| `current-image` | Display current image information (dimensions, size) |
| `recrop-images` | Re-crop all images (run after adding new images) |
| `refresh` | Clear terminal and refresh fastfetch display |
| `clean-all` | Remove all images and re-crop from originals |

### Quick Commands

```bash
# Cycle through images
next-image

# Show a random image
random-image

# See what images are available
list-images

# Get info about current image
current-image

# Refresh the display
refresh
```

## 🔧 Configuration

### Aspect Ratio & Image Settings

You can customize the installation with various options:

```bash
# Custom aspect ratio (width:height)
./install-fastfetch-rotation.sh --aspect 16:9

# Custom image dimensions
./install-fastfetch-rotation.sh --width 800 --logo-height 20

# Different image protocol
./install-fastfetch-rotation.sh --image-type kitty

# Combine multiple options
./install-fastfetch-rotation.sh --aspect 2:1 --width 800 --logo-height 15
```

### Aspect Ratios

Choose the aspect ratio that matches your fastfetch display:

- **1:1** - Square (default, good for most setups)
- **2:1** - Wide (when fastfetch logo is 30x15 characters)
- **16:9** - Widescreen (popular for modern displays)
- **4:3** - Classic (good for older monitors)

### Image Settings

| Option          | Description                                 | Default |
| --------------- | ------------------------------------------- | ------- |
| `--width`       | Maximum width in pixels                     | 600     |
| `--logo-height` | Fastfetch logo height (character cells)     | 15      |
| `--image-type`  | Image protocol (sixel, kitty, iterm2, auto) | sixel   |

## 📁 Directory Structure

```
~/.config/fastfetch/
├── images/                    # Place your original images here
├── cropped/                   # Processed images (auto-generated)
├── config.jsonc              # Fastfetch configuration
├── crop-image.sh             # Image cropping script
├── rotate-images.sh          # Image rotation script
├── image-index.txt           # Current rotation index
└── current-image-*.jpg       # Current active image (timestamped)

~/.config/fish/
├── config.fish               # Fish configuration with wrapper functions
└── functions/
    └── fish_greeting.fish    # Auto-random image on terminal startup
```

## 🛠️ Workflow Examples

### Adding New Images

```bash
# Add a single image
add-image ~/Pictures/wallpaper.jpg

# Add multiple images at once
cp ~/Pictures/*.jpg ~/.config/fastfetch/images/

# Process all images (crops to correct aspect ratio)
recrop-images

# Try the new images
next-image
random-image
```

### Managing Your Image Collection

```bash
# See what images are available
list-images

# Check current image details
current-image

# Switch to next image
next-image

# Randomize
random-image

# Start fresh - recrop all images
recrop-images

# Complete cleanup and recrop
clean-all
```

## 🔄 How It Works

### Image Processing
When you run `recrop-images`, all images in `images/` are:
1. Cropped to your specified aspect ratio
2. Resized to consistent dimensions
3. Saved to the `cropped/` folder

### Rotation Mechanism
Each time you run `next-image` or `random-image`:
1. A unique timestamped copy (`current-image-{timestamp}.jpg`) is created
2. The fastfetch configuration is updated to point to the new file
3. The terminal is cleared and fastfetch refreshes
4. Old files are automatically cleaned up (keeps last 10)

### Cache Bypass
Unique filenames ensure that fastfetch always loads a fresh image, bypassing any terminal or image caching that would otherwise prevent updates.

## 🐛 Troubleshooting

### Images Not Changing
If images don't update when running `next-image`:

1. **Check cropped folder has images:**
   ```bash
   ls ~/.config/fastfetch/cropped/
   ```

2. **Run rotation manually:**
   ```bash
   bash ~/.config/fastfetch/rotate-images.sh
   ```

3. **Check the config:**
   ```bash
   grep "source" ~/.config/fastfetch/config.jsonc
   ```

4. **Clear fastfetch cache:**
   ```bash
   rm -rf ~/.cache/fastfetch
   fastfetch
   ```

## 📝 Customization

### Modify Aspect Ratio After Installation

Edit `~/.config/fastfetch/crop-image.sh` and change:
```bash
ASPECT_W=16   # Width
ASPECT_H=9    # Height
```

Then run:
```bash
recrop-images
```

### Change Logo Size

Edit `~/.config/fastfetch/config.jsonc` and adjust:
```json
"logo": {
    "height": 20,
    "width": 30
}
```

## 🎯 Tips

- **Image Quality**: The default quality is 90%. Adjust the `QUALITY` variable in `crop-image.sh` if needed.
- **Terminal Support**: Use `kitty` or `foot` for the best sixel image support.
- **Startup Speed**: If you have many images, the first random image might take a moment to load.
