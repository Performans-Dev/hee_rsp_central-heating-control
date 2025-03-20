#!/bin/bash

echo "Setting up static assets..."
# Setup directories and variables
BASE_DIR="/home/pi/Heethings"
PICTURES_DIR="$BASE_DIR/pictures"
BASE_URL="https://releases.api2.run/heethings/cc"

# Create directories
mkdir -p "$BASE_DIR"
mkdir -p "$PICTURES_DIR"

# Download and extract images.zip
echo "Downloading and extracting images..."
wget -O "/tmp/images.zip" "$BASE_URL/images.zip"
unzip -o "/tmp/images.zip" -d "$BASE_DIR"
rm "/tmp/images.zip"

# Set splash screen and wallpaper
SPLASH_IMAGE="$BASE_DIR/splash.png"
if [ -f "$SPLASH_IMAGE" ]; then
    echo "Setting up splash screen and wallpaper..."
    # Set as boot splash
    sudo cp "$SPLASH_IMAGE" /usr/share/plymouth/themes/pix/splash.png
    
    # Set wallpaper through config file
    mkdir -p /home/pi/.config/pcmanfm/LXDE-pi
    cat > /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf << EOF
[*]
wallpaper_mode=stretch
wallpaper=$SPLASH_IMAGE
desktop_bg=#000000
desktop_fg=#ffffff
desktop_shadow=#000000
show_wm_menu=0
show_documents=0
show_trash=0
show_mounts=0
desktop_fg_alpha=100
desktop_bg_alpha=100
desktop_shadow_alpha=100
EOF
    chown -R pi:pi /home/pi/.config/pcmanfm
fi

# Download wallpapers
for i in {1..19}; do
    # Format number with leading zero
    num=$(printf "%02d" $i)
    wget -O "$PICTURES_DIR/wp${num}.jpg" "$BASE_URL/images/wp${num}.jpg"
done

echo "Static assets setup complete."
