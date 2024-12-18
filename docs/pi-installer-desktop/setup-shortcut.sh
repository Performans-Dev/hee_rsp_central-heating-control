#!/bin/bash

# Create the installer script
cat > /usr/local/bin/heethings-installer << 'EOF'
#!/bin/bash

# Set display for GUI
export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority

# Function to show error
show_error() {
    zenity --error \
        --title="Heethings Installer Error" \
        --text="$1" \
        --width=400
}

# Function to show progress
show_progress() {
    zenity --info \
        --title="Heethings Installer" \
        --text="$1" \
        --width=400
}

# Check if we have internet connection
if ! ping -c 1 github.com &> /dev/null; then
    show_error "No internet connection. Please connect to the internet and try again."
    exit 1
fi

# Create temporary directory
temp_dir=$(mktemp -d)
cd "$temp_dir" || exit 1

# Download the latest installation script
show_progress "Downloading latest installer..."
if ! curl -L -o install.sh https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/YOUR_REPO/main/install.sh; then
    show_error "Failed to download installation script"
    exit 1
fi

# Make it executable
chmod +x install.sh

# Run the installer
./install.sh

# Clean up
cd /
rm -rf "$temp_dir"
EOF

# Make the installer executable
chmod +x /usr/local/bin/heethings-installer

# Create desktop entry
cat > /usr/share/applications/heethings-installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install Heethings
Comment=Install or update Heethings applications
Exec=pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /usr/local/bin/heethings-installer
Icon=system-software-install
Terminal=false
Categories=System;
EOF

# Create polkit rule to allow pi user to run the installer
cat > /etc/polkit-1/rules.d/90-heethings-installer.rules << 'EOF'
polkit.addRule(function(action, subject) {
    if (action.id === "org.freedesktop.policykit.exec" &&
        subject.user === "pi" &&
        action.lookup("program") === "/usr/local/bin/heethings-installer") {
        return polkit.Result.YES;
    }
});
EOF

# Update desktop database
update-desktop-database

# Show completion message
zenity --info \
    --title="Setup Complete" \
    --text="Installation shortcut has been created on the desktop.\nClick it anytime to install or update Heethings applications." \
    --width=400
