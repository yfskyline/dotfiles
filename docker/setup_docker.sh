#!/bin/bash

# define color / log headers
RED="\033[31;1m"
GREEN="\033[32;1m"
YELLOW="\033[33;1m"
BLUE="\033[34;1m"
CYAN="\033[36;1m"
RESET="\033[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

if [ "$(id -u)" -ne 0 ]; then
	echo -e "$FAILED Please run as root"
	exit 1
fi

apt update -qq
if apt-get install -qq ca-certificates curl; then
	echo -e "$SUCCESS Installed required packages(ca-certificates and curl)"
else
	echo -e "$FAILED Failed to install ca-certificates and curl"
	exit 1
fi
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -qq
if apt-get install -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
	echo -e "$SUCCESS packages required by Docker has installed successfully"
else
	echo -e "$FAILED Docker installation failed"
	echo -e "$SUCCESS packages required by Docker has installed successfully"
	exit 1
fi

if docker run hello-world > /dev/null; then
	echo -e "$SUCCESS Docker installed successfully"
else
	echo -e "$FAILED Docker installation failed"
	exit 1
fi

systemctl start docker
systemctl enable docker
echo -e "$LOG docker status: $(systemctl is-active docker)"
if systemctl is-active docker; then
	echo -e "$SUCCESS Docker installed successfully"
else
	echo -e "$FAILED Docker installation failed"
	exit 1
fi
echo -e "$LOG docker version"
docker version | grep -v 'commit|Commit|Experimental'
if usermod -aG docker "$SUDO_USER"; then
	echo -e "$SUCCESS Added $SUDO_USER to docker group"
else
	echo -e "$FAILED Failed to add $SUDO_USER to docker group"
	exit 1
fi
