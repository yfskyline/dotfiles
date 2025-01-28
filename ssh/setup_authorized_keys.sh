#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run this script with sudo"
	exit 1
fi

# Add ssh keys to the user
su - "$SUDO_USER" -c ssh-import-id gh:yfskyline
# mkdir -p /home/"$SUDO_USER"/.ssh
# curl https://github.com/yfskyline.keys >> /home/"$SUDO_USER"/.ssh/authorized_keys
# chown "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.ssh/authorized_keys
# chmod 600 /home/"$SUDO_USER"/.ssh/authorized_keys

# echo "*/10 * * * * $HOME/dotfiles/ssh/setup_authorized_keys.sh" >> /etc/crontab
echo "*/10 * * * * ssh-import-id gh:yfskyline" >> /etc/crontab
