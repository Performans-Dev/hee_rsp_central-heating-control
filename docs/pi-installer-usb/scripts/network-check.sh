#!/bin/bash

# Network connectivity check script
check_network() {
    local max_attempts=30
    local attempt=1
    local delay=2

    while [ $attempt -le $max_attempts ]; do
        if ping -c 1 google.com >/dev/null 2>&1; then
            echo "Network is available"
            return 0
        fi
        echo "Waiting for network... attempt $attempt of $max_attempts"
        sleep $delay
        attempt=$((attempt + 1))
    done

    echo "Network connectivity check failed"
    return 1
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    check_network
    exit $?
fi
