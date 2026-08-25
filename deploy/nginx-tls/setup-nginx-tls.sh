#!/bin/bash
# ==========================================
# Install Nginx + Certbot on Ubuntu, issue TLS cert.
# Run once on the Ubuntu host as root or with sudo.
# ==========================================

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./setup-nginx-tls.sh"
    exit 1
fi

DOMAIN="${1:-yourdomain.com}"

echo "Installing Nginx + Certbot..."

sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx

sudo systemctl enable nginx
sudo systemctl start nginx

# Allow HTTP+HTTPS
if command -v ufw >/dev/null 2>&1; then
    sudo ufw allow 'Nginx Full'
    sudo ufw reload
fi

# Place the config (assumes you copied it to /etc/nginx/sites-available/ecommerce-card)
echo "=========================================="
echo "Next steps:"
echo "1. Copy nginx-tls.conf → /etc/nginx/sites-available/ecommerce-card"
echo "   (edit 'yourdomain.com' to your real domain first)"
echo "2. sudo ln -s /etc/nginx/sites-available/ecommerce-card /etc/nginx/sites-enabled/"
echo "3. sudo nginx -t"
echo "4. sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN"
echo "5. sudo systemctl reload nginx"
echo "=========================================="
