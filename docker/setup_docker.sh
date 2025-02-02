#!/bin/bash

# define color / log headers
RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
CYAN="\033[36;1m"
RESET="\e[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

if [ "$(id -u)" -ne 0 ]; then
	echo -e "$FAILED Please run as root"
	exit 1
fi

apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker run hello-world

systemctl start docker
systemctl enable docker
echo -e "$LOG docker status: $(systemctl is-active docker)"
if systemctl is-active docker; then
	echo -e "$SUCCESS Docker installed successfully"
else
	echo -e "$FAILED Docker installation failed"
	exit 1
fi
echo "$LOG docker version"
docker version | grep -v 'commit|Commit|Experimental'
if usermod -aG docker "$SUDO_USER"; then
	echo -e "$SUCCESS Added $SUDO_USER to docker group"
else
	echo -e "$FAILED Failed to add $SUDO_USER to docker group"
	exit 1
fi
