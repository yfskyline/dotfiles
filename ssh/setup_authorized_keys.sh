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

	# Update SSH public keys every 10 minutes
	if ! command -v ssh-import-id > /dev/null 2>&1; then
		echo "ssh-import-id is not installed"
		exit 1
	fi

	if printf '*/10 * * * * %s /usr/bin/ssh-import-id gh:yfskyline\n' "$TARGET_USER" > /etc/cron.d/ssh_import_id; then
		chown root:root /etc/cron.d/ssh_import_id
		chmod 644 /etc/cron.d/ssh_import_id
	else
		echo "Failed to configure SSH key update cron"
		exit 1
	fi
elif [ "$OS" = 'Darwin' ]; then
	# Add ssh keys to the user
	mkdir -p /Users/"$SUDO_USER"/.ssh
	curl https://github.com/yfskyline.keys >> /Users/"$SUDO_USER"/.ssh/authorized_keys
	chown "$SUDO_USER":"$SUDO_USER" /Users/"$SUDO_USER"/.ssh/authorized_keys
	chmod 600 /Users/"$SUDO_USER"/.ssh/authorized_keys
	uniq -u authorized_keys > tmp && mv -f tmp authorized_keys
fi
