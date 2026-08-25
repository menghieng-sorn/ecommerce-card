#!/bin/bash
# ==========================================
# Install Caddy on Ubuntu 22.04/24.04 and serve the Caddyfile
# Run once on the Ubuntu host as root or with sudo.
# ==========================================

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./setup-caddy.sh"
    exit 1
fi

echo "Installing Caddy..."

# Add Caddy GPG key + repo
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | \
    sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/deb/debian/dists/stable/main/binary-amd64/Packages' | \
    sudo tee /etc/apt/sources.list.d/caddy-stable.list > /dev/null
sudo apt update
sudo apt install -y caddy

# Enable + start
sudo systemctl enable caddy
sudo systemctl restart caddy

# Allow HTTP+HTTPS through firewall
if command -v ufw >/dev/null 2>&1; then
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw reload
fi

echo "=========================================="
echo "Caddy installed."
echo "Now copy your Caddyfile to /etc/caddy/Caddyfile"
echo "  sudo cp Caddyfile /etc/caddy/Caddyfile"
echo "  sudo systemctl reload caddy"
echo "=========================================="
