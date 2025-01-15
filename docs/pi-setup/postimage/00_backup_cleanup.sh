#!/bin/bash

# =============================================================================
# Phase 2.0: Backup and Cleanup
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/postimage/common.sh"

# Exit on error
set -e

BASE_DIR="/home/pi/Heethings"
BACKUP_DIR="/home/pi/heethings_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/heethings_backup_$TIMESTAMP.zip"

log "INFO" "Starting backup and cleanup process..."

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Remove existing menu items and autostart entries
log "INFO" "Removing existing menu and autostart items..."
rm -f /usr/share/applications/heethings-cc.desktop
rm -f /usr/share/applications/heethings-elevator.desktop
rm -f /usr/share/applications/heethings-diagnose.desktop
rm -f /home/pi/.config/autostart/heethings.desktop

# Remove old command shortcuts
log "INFO" "Removing old command shortcuts..."
rm -f /usr/local/bin/cc
rm -f /usr/local/bin/cc-elevator
rm -f /usr/local/bin/cc-diagnose
rm -f /usr/local/bin/heethings-cc
rm -f /usr/local/bin/heethings-cc-elevator
rm -f /usr/local/bin/heethings-cc-diagnose

# Function to cleanup old backups keeping only the last N
cleanup_old_backups() {
    local keep_count=$1
    local backup_count=$(ls -1 "$BACKUP_DIR"/heethings_backup_*.zip 2>/dev/null | wc -l)
    
    if [ "$backup_count" -gt "$keep_count" ]; then
        log "INFO" "Cleaning up old backups (keeping last $keep_count)..."
        ls -1t "$BACKUP_DIR"/heethings_backup_*.zip | tail -n +$((keep_count + 1)) | xargs rm -f
        log "INFO" "✓ Old backups cleaned up"
    fi
}

# Check if Heethings directory exists
if [ -d "$BASE_DIR" ]; then
    log "INFO" "Found existing Heethings installation"
    
    # Create backup
    log "INFO" "Creating backup at: $BACKUP_FILE"
    if zip -r "$BACKUP_FILE" "$BASE_DIR" 2>/dev/null; then
        log "INFO" "✓ Backup created successfully"
        
        # Cleanup old backups keeping last 3
        cleanup_old_backups 3
        
        # Show confirmation dialog
        if dialog --title "⚠️ Warning" --yesno "\nExisting installation found and backed up to:\n$BACKUP_FILE\n\nThis will remove the current installation completely.\nAre you sure you want to proceed?" 12 60; then
            log "INFO" "Removing existing installation..."
            rm -rf "$BASE_DIR"
            log "INFO" "✓ Cleanup completed"
        else
            log "INFO" "Operation cancelled by user"
            exit 1
        fi
    else
        log "WARN" "⚠️ Warning: Backup creation failed"
        if ! dialog --title "⚠️ Warning" --yesno "\nBackup creation failed!\n\nDo you want to proceed anyway?\nThis will remove the current installation without backup!" 10 50; then
            log "INFO" "Operation cancelled by user"
            exit 1
        fi
    fi
else
    log "INFO" "No existing installation found, proceeding with fresh install"
fi
