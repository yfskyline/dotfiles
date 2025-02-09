#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

if [ -n "$1" ]; then
	TARGET_USER="$1"
	echo "Using $TARGET_USER as the target user"
else
	echo -n "Enter the username: "
	read -r TARGET_USER
	echo "Using $TARGET_USER as the target user"
fi

# set $OS
if [ "$(uname -s | cut -c1-5)" = 'Linux' ]; then
	OS='Linux'
elif [ "$(uname -s | cut -c1-6)" = 'Darwin' ]; then
	OS='Darwin'
else
	echo "Unsupported OS"
	exit 1
fi

if [ "$OS" = 'Linux' ]; then
	# Add ssh keys to the user
	su - "$TARGET_USER" -c 'ssh-import-id gh:yfskyline'
	# mkdir -p /home/"$SUDO_USER"/.ssh
	# curl https://github.com/yfskyline.keys >> /home/"$SUDO_USER"/.ssh/authorized_keys
	# uniq -u authorized_keys > tmp && mv -f tmp authorized_keys
	# chown "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.ssh/authorized_keys
	# chmod 600 /home/"$SUDO_USER"/.ssh/authorized_keys

	# echo "*/10 * * * * $HOME/dotfiles/ssh/setup_authorized_keys.sh" >> /etc/crontab
	echo "*/10 * * * * ssh-import-id gh:yfskyline" >> /etc/crontab
elif [ "$OS" = 'Darwin' ]; then
	# Add ssh keys to the user
	mkdir -p /Users/"$SUDO_USER"/.ssh
	curl https://github.com/yfskyline.keys >> /Users/"$SUDO_USER"/.ssh/authorized_keys
	chown "$SUDO_USER":"$SUDO_USER" /Users/"$SUDO_USER"/.ssh/authorized_keys
	chmod 600 /Users/"$SUDO_USER"/.ssh/authorized_keys
	uniq -u authorized_keys > tmp && mv -f tmp authorized_keys
fi
