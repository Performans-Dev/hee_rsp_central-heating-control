#!/bin/bash

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPLETED_FILE="$SCRIPT_DIR/.completed_steps"

# Create or read completed steps file
touch "$COMPLETED_FILE"

# Function to check if a step is completed
is_completed() {
    grep -q "^$1$" "$COMPLETED_FILE"
}

# Function to mark a step as completed
mark_completed() {
    echo "$1" >> "$COMPLETED_FILE"
}

# Function to run a script if not already completed
run_step() {
    local script="$1"
    local step_name=$(basename "$script" .sh)
    
    if ! is_completed "$step_name"; then
        echo "Running $step_name..."
        if sudo bash "$script"; then
            mark_completed "$step_name"
            echo "$step_name completed successfully."
        else
            echo "Error: $step_name failed."
            exit 1
        fi
    else
        echo "Skipping $step_name (already completed)"
    fi
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

echo "=== Running Pre-image Setup ==="

# Run each script in sequence
for script in "$SCRIPT_DIR"/[0-9][0-9]_*.sh; do
    if [ -f "$script" ]; then
        run_step "$script"
    fi
done

echo "All pre-image setup steps completed."
echo
read -p "Hit Enter to reboot now, any other key to reboot later: " -n 1 -r
echo
if [[ $REPLY == "" ]]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "You can reboot later by running 'sudo reboot'"
fi
