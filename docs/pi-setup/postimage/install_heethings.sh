#!/bin/bash

# =============================================================================
# Main Installation Script
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/postimage/common.sh"

log "INFO" "Starting Heethings installation..."

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log "ERROR" "Please run as root (sudo)"
    exit 1
fi

BASE_DIR="/home/pi/Heethings"
CC_DIR="$BASE_DIR/CC"

# Function to run a script and check its exit status
run_script() {
    local phase=$1
    local script=$2
    log "INFO" "Running $phase/$script..."
    if bash "$SCRIPT_DIR/$phase/$script"; then
        log "INFO" "✓ $script completed successfully"
    else
        log "ERROR" "✗ $script failed"
        exit 1
    fi
}

# Show initial warning dialog
show_warning_dialog() {
    log "INFO" "Showing warning dialog..."
    dialog --title "⚠️ Warning" --yesno "\nThis will install/repair Heethings Central Heating Control.\n\nThis process will:\n- Backup existing installation\n- Remove current installation\n- Install fresh copy of all components\n\nDo you want to continue?" 15 60
    return $?
}

# Main installation process
log "INFO" "=== Heethings Installation/Repair Tool ==="

# Show warning dialog
if ! show_warning_dialog; then
    log "INFO" "Installation cancelled by user"
    clear
    echo "Installation cancelled."
    exit 0
fi

clear

log "INFO" "Running post-image setup scripts..."
# Run all post-image scripts in order
run_script "postimage" "00_backup_cleanup.sh"     # Backup and remove existing installation
run_script "postimage" "01_directory_setup.sh"    # Create directory structure
run_script "postimage" "02_download_apps.sh"      # Download latest applications
run_script "postimage" "03_extract_files.sh"      # Extract downloaded files
run_script "postimage" "04_service_setup.sh"      # Configure system services
run_script "postimage" "05_final_setup.sh"        # Final verification

log "INFO" "Installation completed successfully"
dialog --title "✓ Success" --msgbox "\nInstallation completed successfully!\nBackups can be found in /home/pi/heethings_backups\n\nLogs available at:\n- /var/log/heethings_install.log\n- /var/log/heethings_error.log" 10 60
clear
