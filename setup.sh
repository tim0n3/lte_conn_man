#!/bin/bash

# Log file location
LOG_FILE="/var/log/connman_install.log"

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

# Function to handle errors
handle_error() {
    log "Error: $1"
    exit 1
}

log "Starting installation process..."


log "Installer will now setup"
log "wwan0 iface and lte manager services"

