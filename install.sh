#!/bin/sh

# Stop script on error
set -e

echo "-----------------------------------------------------"
echo "  SOCKS5 / BDIX Proxy Installer for OpenWRT"
echo "-----------------------------------------------------"

echo "[1/4] Updating package lists..."
opkg update || echo "Warning: opkg update failed, trying to continue..."

echo "[2/4] Installing dependencies..."
# Install packages individually to save memory on small routers
opkg install iptables || true
opkg install iptables-mod-nat-extra || true
opkg install redsocks

echo "[3/4] Downloading configuration files..."

# Stop original redsocks service to prevent conflicts
if [ -f /etc/init.d/redsocks ]; then
    /etc/init.d/redsocks stop 2>/dev/null || true
    /etc/init.d/redsocks disable 2>/dev/null || true
fi

# Move old configs if they exist
[ -f /etc/bdix.conf ] && mv /etc/bdix.conf /etc/bdix.conf.old
[ -f /etc/init.d/bdix ] && rm /etc/init.d/bdix

# Download files (forcing HTTPS checks off for compatibility with old routers)
wget --no-check-certificate -O /etc/bdix.conf https://github.com/detekfitfounder/socks5-openrouter/raw/main/bdix.conf
wget --no-check-certificate -O /etc/bdix.whitelist https://github.com/detekfitfounder/socks5-openrouter/raw/main/bdix.whitelist 2>/dev/null || true
wget --no-check-certificate -O /etc/init.d/bdix https://github.com/detekfitfounder/socks5-openrouter/raw/main/bdix

chmod +x /etc/init.d/bdix

echo "[4/4] Starting Service..."
/etc/init.d/bdix enable
/etc/init.d/bdix restart

echo "-----------------------------------------------------"
echo "✅ Installation Successful!"
echo "   - Config: /etc/bdix.conf"
echo "   - Whitelist: /etc/bdix.whitelist"
echo "-----------------------------------------------------"