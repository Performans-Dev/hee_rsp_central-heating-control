#!/bin/bash

# This script prepares a USB drive with the correct permissions
# Run this on a Linux/Mac system before distributing the USB drives

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make all scripts executable
chmod +x "$SCRIPT_DIR/install.sh"
chmod +x "$SCRIPT_DIR/autorun.sh"
chmod +x "$SCRIPT_DIR/scripts/"*.sh

# Create a FAT32 filesystem label that indicates this is a Heethings installer
# (This part should be run when actually preparing the USB drive)
echo "To prepare a USB drive:"
echo "1. Insert a USB drive"
echo "2. Run the following commands (replace /dev/sdX with your USB device):"
echo ""
echo "  sudo mkfs.vfat -n HEETHINGS /dev/sdX"
echo "  sudo mount /dev/sdX /mnt"
echo "  sudo cp -r $SCRIPT_DIR/* /mnt/"
echo "  sudo umount /mnt"
echo ""
echo "The USB drive will now be ready for distribution!"
