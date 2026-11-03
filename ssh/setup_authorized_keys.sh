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
	if [ -z "${SUDO_USER:-}" ] || [ "$SUDO_USER" = "root" ]; then
		echo "Run this script using sudo from a normal user."
		exit 1
	fi
	# Add SSH keys to the user
	ssh_dir="/Users/$SUDO_USER/.ssh"
	auth_keys="$ssh_dir/authorized_keys"
	mkdir -p "$ssh_dir" || exit 1
	chown "$SUDO_USER" "$ssh_dir" || exit 1
	chmod 700 "$ssh_dir" || exit 1

	downloaded="$(mktemp)" || exit 1
	tmp="$(mktemp "${auth_keys}.XXXXXXXX")" || {
		rm -f "$downloaded"
		exit 1
	}

	previous="/dev/null"
	[ -f "$auth_keys" ] && previous="$auth_keys"

	if ! curl -fsSL https://github.com/yfskyline.keys -o "$downloaded" ||
		[ ! -s "$downloaded" ] ||
		! awk 'NF && !seen[$0]++' "$previous" "$downloaded" > "$tmp" ||
		! chown "$SUDO_USER" "$tmp" ||
		! chmod 600 "$tmp" ||
		! mv -f "$tmp" "$auth_keys"; then
		rm -f "$downloaded" "$tmp"
		exit 1
	fi

	rm -f "$downloaded"
fi
