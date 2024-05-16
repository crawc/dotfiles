#!/bin/bash

# Find all dot files then if the original file exists, create a backup
# Once backed up to {file}.dtbak symlink the new dotfile in place
for file in $(find . -maxdepth 1 -name ".*" -type f  -printf "%f\n" ); do
    if [ -e ~/$file ]; then
        mv -f ~/$file{,.dtbak}
    fi
    ln -s $PWD/$file ~/$file
done

current_user=$(whoami)
echo "$current_user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$current_user >/dev/null
sudo chmod 440 /etc/sudoers.d/$current_user

# Set the timezone to America/New_York
sudo timedatectl set-timezone America/New_York

#

echo "Starting the SSH server reinstallation process..."

# Remove existing OpenSSH server and its configuration files
echo "Removing existing OpenSSH server..."
sudo apt purge -y openssh-server
sudo rm -rf /etc/ssh/
echo "OpenSSH server removed."

# Reinstall OpenSSH server
echo "Reinstalling OpenSSH server..."
sudo apt install -y openssh-server
echo "OpenSSH server reinstalled."

# Path to the SSH configuration file
SSH_CONFIG="/etc/ssh/sshd_config"

# Make a backup of the new SSH configuration file
echo "Backing up the new SSH configuration file..."
sudo cp $SSH_CONFIG $SSH_CONFIG.backup
echo "Backup created."

# Enable PasswordAuthentication, handle variations in spacing and existing no/yes
echo "Enabling PasswordAuthentication..."
sudo sed -i '/^# *PasswordAuthentication no/s/^# *//' $SSH_CONFIG
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' $SSH_CONFIG
sudo sed -i '/^# *PasswordAuthentication yes/s/^# *//' $SSH_CONFIG

# Permit root login, handle variations in spacing
echo "Enabling root login..."
sudo sed -i '/^# *PermitRootLogin prohibit-password/s/^# *//' $SSH_CONFIG
sudo sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' $SSH_CONFIG
sudo sed -i '/^# *PermitRootLogin yes/s/^# *//' $SSH_CONFIG

# Restart SSH service to apply changes
echo "Restarting SSH service to apply changes..."
sudo systemctl restart sshd
echo "SSH service restarted successfully."

echo "SSH configuration updated and service restarted successfully."
