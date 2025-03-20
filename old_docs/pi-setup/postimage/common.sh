#!/bin/bash

# Common variables
INSTALL_LOG="/var/log/heethings_install.log"
ERROR_LOG="/var/log/heethings_error.log"

# Ensure log files exist and are writable
sudo touch "$INSTALL_LOG" "$ERROR_LOG"
sudo chmod 666 "$INSTALL_LOG" "$ERROR_LOG"

# Logging function
log() {
    local level=$1
    shift
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] [$level] [${BASH_SOURCE[1]}:${BASH_LINENO[0]}] $*"
    echo "$message" | tee -a "$INSTALL_LOG"
    if [ "$level" = "ERROR" ]; then
        echo "$message" | tee -a "$ERROR_LOG"
    fi
}

# Error handler
handle_error() {
    local line_no=$1
    local error_code=$2
    log "ERROR" "Error occurred in script at line $line_no (exit code: $error_code)"
}

# Set error trap
trap 'handle_error ${LINENO} $?' ERR
