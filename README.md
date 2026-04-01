# Fastfetch Image Rotation System

A complete solution for rotating and randomizing images in fastfetch with automatic cropping and terminal refresh support.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Fish Shell](https://img.shields.io/badge/shell-fish-blue.svg)](https://fishshell.com/)
[![Fastfetch](https://img.shields.io/badge/fastfetch-2.x-green.svg)](https://github.com/fastfetch-cli/fastfetch)

## ✨ Features

- 🖼️ **Automatic Image Rotation** - Switch between images with a single command
- 🎲 **Random Image Selection** - Get a random image on demand or on terminal startup
- ✂️ **Smart Cropping** - Automatically crops images to your preferred aspect ratio
- 🚀 **Terminal Cache Bypass** - Unique filenames ensure fresh images every time
- 🎨 **Customizable** - Configurable aspect ratios, image sizes, and display dimensions
- 🐟 **Fish Shell Integration** - Seamless integration with Fish shell functions
- 📦 **One-Command Install** - Single script handles everything

## 📋 Prerequisites

- **fastfetch** - System information tool
- **ImageMagick** - Image processing (for cropping)
- **Fish Shell** - Modern shell with nice features
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


### Basic Commands

After installation, these Fish shell functions are available:

|Command|Description|
|---|---|
|`next-image`|Rotate to the next image in your collection|
|`random-image`|Select and display a random image|
|`list-images`|Show all available cropped images|
|`current-image`|Display current image information|
|`recrop-images`|Re-crop all images (run after adding new images)|
|`add-image`|Add a new image (usage: `add-image /path/to/image.jpg`)|
|`refresh`|Refresh the terminal display|


### Workflow Example
``` bash
# 1. Add images to your collection
add-image ~/Pictures/wallpaper.jpg
add-image ~/Downloads/logo.png

# 2. Add multiple images at once
cp ~/Pictures/*.jpg ~/.config/fastfetch/images/

# 3. Process all images (crops to correct aspect ratio)
recrop-images

# 4. Try different images
next-image     # Next image in sequence
random-image   # Random image

# 5. See what's available
list-images

# 6. Check current image details
current-image
```


### Custom Installation Options

The installer supports various customization options:

``` bash

# Custom aspect ratio (width:height)
./install-fastfetch-rotation.sh --aspect 16:9
# Custom image dimensions
./install-fastfetch-rotation.sh --width 800 --logo-height 20 --logo-width 20
# Different image protocol (kitty, iterm2, sixel, auto)
./install-fastfetch-rotation.sh --image-type kitty
# Combine options
./install-fastfetch-rotation.sh --aspect 2:1 --width 800 --logo-height 15 --logo-width 30

```
## 🔧 Configuration

### Aspect Ratios

Choose the aspect ratio that matches your terminal's character cells:

- **1:1** - Square (default, good for most setups)
    
- **2:1** - Wide (if your fastfetch logo is 30x15)
    
- **16:9** - Widescreen (popular for modern displays)
    
- **4:3** - Classic (good for older monitors)

### Image Settings

- **--width**: Maximum width in pixels (default: 600)
    
- **--logo-height**: Fastfetch logo height in character cells (default: 15)
    
- **--logo-width**: Fastfetch logo width in character cells (default: 15)
    
- **--image-type**: Image protocol (sixel, kitty, iterm2, auto)

### Directory Structure

``` text

~/.config/fastfetch/
├── images/           # Place your original images here
├── cropped/          # Processed images (auto-generated)
├── config.jsonc      # Fastfetch configuration
├── crop-image.sh     # Image cropping script
├── rotate-images.sh  # Image rotation script
└── current-image-*.jpg # Current active image (timestamped)
~/.config/fish/
├── config.fish       # Fish configuration (functions added)
└── functions/
    └── fish_greeting.fish # Auto-random on startup

```
## 🛠️ How It Works

1. **Image Processing**: When you run `recrop-images`, all images in `images/` are cropped to your specified aspect ratio and resized to a consistent width.
    
2. **Rotation**: Each time you run `next-image` or `random-image`, a timestamped copy is created, ensuring your terminal loads a fresh file (bypassing caching).
    
3. **Display**: Fastfetch is configured to display the current image file, and the terminal is refreshed automatically.
    
4. **Terminal Integration**: Fish shell functions provide intuitive commands, and the greeting function ensures a random image on each new terminal session.
