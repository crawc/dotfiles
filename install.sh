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

sudo -i -u $current_user
update

echo "Do you want to install Docker? (y/n)"
read answer

if [ "$answer" == "y" ]; then
    # Make the script executable
    chmod +x install-docker.sh

    # Run the script
    ./install-docker.sh
else
    echo "Docker installation aborted."
fi
