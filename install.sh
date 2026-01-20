#!/bin/sh

# Update package
opkg update

#install packages
opkg install iptables iptables-mod-nat-extra redsocks ipset

#Then run this line
service redsocks stop
mv /etc/redsocks.conf /etc/redsocks.conf.bkp
cd /etc
wget https://github.com/detekfitfounder/socks5-openrouter/raw/main/bdix.conf
wget https://github.com/detekfitfounder/socks5-openrouter/raw/main/whitelist.txt -O /etc/bdix_whitelist.txt

# Generate dnsmasq config for whitelist
echo "# BDIX Whitelist" > /etc/bdix_dnsmasq.conf
while read p; do
  echo "ipset=/$p/bdix_whitelist" >> /etc/bdix_dnsmasq.conf
done < /etc/bdix_whitelist.txt

# Create ipset if not exists (so dnsmasq doesn't complain on restart before bdix starts)
ipset -N bdix_whitelist hash:ip 2>/dev/null

# Add to dnsmasq.conf if not present
if ! grep -q "conf-file=/etc/bdix_dnsmasq.conf" /etc/dnsmasq.conf; then
    echo "conf-file=/etc/bdix_dnsmasq.conf" >> /etc/dnsmasq.conf
fi
/etc/init.d/dnsmasq restart

mv /etc/init.d/redsocks /etc/init.d/redsocks.bkp
cd /etc/init.d
wget https://github.com/detekfitfounder/socks5-openrouter/raw/main/bdix
chmod +x /etc/init.d/bdix

cd /
clear


echo -e "Thanks for installing. Follow me for more updates: @detekfitfounder"
