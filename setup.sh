#!/bin/bash

# Log file location
LOG_FILE="/var/log/connman_install.log"

# Global vars
timer_File="my_script.timer"
timer_Path="/etc/systemd/system/$timer_File"
service_File="lte.service"
service_Path="/etc/systemd/system/$service_File"
app_File="start_LTE.sh"
app_Path="/root/$app_File"

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

# Function to handle errors
handle_error() {
    log "Error: $1"
    exit 1
}


# Function to cleanly exit upon success
clean_escape() {
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] :  All components installed Successfully!!!"
	log " All components installed Successfully!!!"
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] : Successfully executed: $0"
	log "Successfully executed: $0"
	exit 0
}

# Function to install the service
install_service() {
    cp services/lte.service /etc/systemd/system/
    # Reload daemons
     echo "reloading systemd"
     log "reloading systemd"
    systemctl daemon-reload
    sleep 1
    # Enable timer service
    log "enabling lte service"
    systemctl enable lte.service
    sleep 1
}

# Function to install the timer
install_timer() {
    log "Starting timer installation"
    cp services/my_script.timer /etc/systemd/system/
     # Reload daemons
     echo "reloading systemd"
     log "reloading systemd"
    systemctl daemon-reload
    sleep 1
    # Enable timer service
    log "enabling timer service"
    systemctl enable my_script.timer
    sleep 1
}  

# Function to move app into correct folder
install_app() {
    cp app/start_LTE.sh /root/
}

app_checker() {
    # Check the services are installed correctly
    if [ -e "$app_Path" ]; then
        log "Files $app_File exists in /root/ folder."
    else
        log "Setting up app_ "
        cp app/start_LTE.sh /root/
    fi
}

start_services() {
    # Start the services
    log "Starting timer"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] : Starting timer"
    systemctl restart my_script.timer
    sleep 1
    log "Starting service"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] : Starting service"
    systemctl restart lte.service
    sleep 1
    log "Services have been Successfully installed and setup"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] : Services have been Successfully installed and setup"
}

service_checker() {
    # Check the service is running
    service_STATUS="$(systemctl is-active lte.service)"
    if [ "${service_STATUS}" = "active" ]; then
        log "Service is running."
    else
        echo " Service not running.... so exiting with Fail "
        handle_error
    fi
}

timer_checker() {
     # Check the timer is running
    timer_STATUS="$(systemctl is-active my_script.timer)"
    if [ "${timer_STATUS}" = "active" ]; then
        log "Timer is running."
    else
        echo " Service not running.... so exiting with Fail "
        log " Service not running.... so exiting with Fail "
        log " Try manually running the timer "
        handle_error
    fi
}

# Main method / Function
## This is the first function to run in this program
_main() {

    log "Starting installation process..."

    # Check the services are installed correctly
    if [ -e "$service_Path" ]; then
        log "Files $service_File exists in /etc/systemd/system/ folder."
    else
        log "Setting up services_ "
        install_service
    fi

    # Check the timer is installed correctly
    if [ -e "$timer_Path" ]; then
        log "Files $timer_File exists in /etc/systemd/system/ folder."
    else
        log "Setting up services_ "
        install_timer
    fi
   log "_main() has completed... moving to exit function"
}

clean_escape