#!/bin/bash

# Check if the script is run with root privileges
if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Get the new hostname from the user
read -p "Enter the new hostname: " NEW_HOSTNAME

# Backup existing configuration files
cp /etc/hostname /etc/hostname.bak
cp /etc/hosts /etc/hosts.bak

# Display current hostname
CURRENT_HOSTNAME=$(cat /etc/hostname)
echo "Current hostname: $CURRENT_HOSTNAME"
echo "New hostname: $NEW_HOSTNAME"

# Update /etc/hostname
echo "$NEW_HOSTNAME" > /etc/hostname

# Update /etc/hosts
sed -i "s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts

# Show the changes
echo -e "\nChanges to be made:"
echo "1. /etc/hostname will be updated to: $NEW_HOSTNAME"
echo "2. /etc/hosts will be updated to replace $CURRENT_HOSTNAME with $NEW_HOSTNAME"

# Ask for confirmation
read -p "Do you want to proceed with these changes and reboot? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "Aborting the update."
    exit 1
fi

# Reboot the system
echo "Rebooting the system..."
reboot
