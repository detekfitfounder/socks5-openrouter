# SOCKS5 / BDIX Proxy Service for OpenWRT

A robust and stable SOCKS5 client implementation for OpenWRT routers using `redsocks`, `procd`, and `ipset`. This setup allows you to route traffic through a SOCKS5 proxy (like BDIX) with domain-based whitelisting (Direct Connection).

## Features
- **Auto-Reconnect**: Uses OpenWRT's `procd` system to automatically restart the proxy service if it crashes or disconnects.
- **Domain Whitelisting**: Easily specify domains (like `facebook.com`) to bypass the proxy using a simple text file.
- **Stability**: Prevents internet lockouts and ensures the proxy service runs reliably.
- **Safety**: proxy is restricted to LAN interface `br-lan` to prevent WAN exposure.

---

## 🚀 Installation

Run the following command on your OpenWRT router via SSH to install the service automatically:

```bash
opkg update && opkg install wget && cd /tmp && rm -f install.sh && wget -O install.sh https://github.com/detekfitfounder/socks5-openrouter/raw/main/install.sh && chmod +x install.sh && ./install.sh
```

This script will:
1. Install required packages (`redsocks`, `iptables`, `ipset`, `iptables-mod-nat-extra`).
2. Configure `dnsmasq` for domain whitelisting.
3. Install the `bdix` service.

---

## ⚙️ Configuration

### 1. Configure SOCKS5 Proxy
To set your proxy details (IP, Port, Username, Password), edit the config file:

```bash
vi /etc/bdix.conf
```

Update the `redsocks` section:
```conf
redsocks {
    local_ip = 0.0.0.0;
    local_port = 1337;
    ip = YOUR_PROXY_IP;
    port = YOUR_PROXY_PORT;
    type = socks5;
    login = "YOUR_USERNAME";
    password = "YOUR_PASSWORD";
}
```

### 2. Configure Domain Whitelist (Direct Connection)
Domains listed in the whitelist will **bypass** the proxy and use your direct internet connection.

1. Edit the whitelist file:
   ```bash
   vi /etc/bdix_whitelist.txt
   ```
2. Add domains one per line. Example:
   ```text
   facebook.com
   messenger.com
   whatismyip.com
   ```
3. **Apply Changes**:
   Whenever you edit the whitelist, you must restart `dnsmasq` and `bdix` to update the IP sets:
   
   ```bash
   service dnsmasq restart
   service bdix restart
   ```

---

## 🏛 Managing the Service

**Start Service:**
```bash
service bdix start
```

**Stop Service:**
```bash
service bdix stop
```

**Restart Service:**
```bash
service bdix restart
```

**Enable Auto-Start on Boot:**
```bash
service bdix enable
```

**Disable Auto-Start:**
```bash
service bdix disable
```

---

## ❌ Uninstalling

To completely remove the service:

```bash
service bdix stop
service bdix disable
rm /etc/init.d/bdix
rm /etc/bdix.conf
rm /etc/bdix_whitelist.txt
rm /etc/bdix_dnsmasq.conf
# You may also want to remove the include line from /etc/dnsmasq.conf manually
```

Reboot your router after uninstalling.
