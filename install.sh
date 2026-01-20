#!/bin/sh
set -e

echo "Updating packages..."
opkg update

echo "Installing dependencies..."
opkg install iptables iptables-mod-nat-extra redsocks sed

echo "Stopping existing services..."
[ -f /etc/init.d/redsocks ] && service redsocks stop || true

# Backup existing configs
[ -f /etc/redsocks.conf ] && mv /etc/redsocks.conf /etc/redsocks.conf.bkp
[ -f /etc/init.d/redsocks ] && mv /etc/init.d/redsocks /etc/init.d/redsocks.bkp

echo "Downloading configuration files..."
wget -O /etc/bdix.conf https://github.com/detekfitfounder/socks5-openrouter/raw/main/bdix.conf

echo "Installing BDIX service..."
wget -O /etc/init.d/bdix https://github.com/detekfitfounder/socks5-openrouter/raw/main/bdix
chmod +x /etc/init.d/bdix

# Fix potential Windows line endings (CRLF) in downloaded scripts
sed -i 's/\r$//' /etc/init.d/bdix
sed -i 's/\r$//' /etc/bdix.conf

echo "Enabling BDIX service..."
service bdix enable
service bdix start

echo "Installation Complete!"
echo "Follow me for updates: @detekfitfounder"
