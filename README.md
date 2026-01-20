# SOCKS5 / BDIX Proxy Service for OpenWRT

A robust and stable SOCKS5 client implementation for OpenWRT routers using `redsocks` and `procd`. This setup allows you to route traffic through a SOCKS5 proxy (like BDIX).

## Features
- **Auto-Reconnect**: Uses OpenWRT's `procd` system to automatically restart the proxy service if it crashes or disconnects.
- **Stability**: Prevents internet lockouts and ensures the proxy service runs reliably.
- **Safety**: proxy is restricted to LAN interface `br-lan` to prevent WAN exposure.

---

## 🚀 Installation

Run the following command on your OpenWRT router via SSH to install the service automatically.
**Note:** This command first corrects your router's date to ensure SSL downloads work.

```bash
cd /tmp && wget https://github.com/detekfitfounder/socks5-openrouter/raw/main/install.sh && chmod +x install.sh && clear && sh install.sh && rm install.sh
```

This script will:
1. Install required packages (`redsocks`, `iptables`, `iptables-mod-nat-extra`).
2. Install the `bdix` service.

---

## ⚙️ Configuration

### Configure SOCKS5 Proxy
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

### 📋 Whitelisting Domains
By default, Facebook, Messenger, and some common BDIX sites are whitelisted (bypass the proxy). 
To add your own domains or IPs to the whitelist, create a file:

```bash
vi /etc/bdix.whitelist
```

Add one domain or IP per line:
```text
youtube.com
googlevideo.com
1.1.1.1
```
Then restart the service: `service bdix restart`

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
```

Reboot your router after uninstalling.

---

## ❓ Troubleshooting

### Error: "wget returned 5" or "Failed to download package list"
This error indicates an **SSL Certificate Verification Failure**, usually because your router's date and time are incorrect (e.g., reset to 1970 after a reboot).

**Fix**:
1. Check the current date on your router:
   ```bash
   date
   ```
2. If the date is wrong, set it manually (YYYY-MM-DD HH:MM:SS):
   ```bash
   date -s "2026-01-20 16:20:00"
   ```
   *(Replace with the current actual time)*.

3. Try running the installation command again.

### Installation Stuck or No Internet
If you had a failed proxy setup previously, your firewall might be blocking traffic. Run this to reset firewall rules:
```bash
iptables -t nat -F
service firewall restart
```
Then try installing again.

### Website Loading Slow? (DNS Issues)
This proxy setup (**RedSocks**) only forwards **TCP** traffic. DNS requests (UDP) usually go directly through your ISP.
- If your ISP throttles DNS or international traffic, this can cause delays.
- **Fix**: Set your router's DNS to a fast public DNS (like `1.1.1.1` or `8.8.8.8`) or your ISP's local DNS server in OpenWRT Network settings.
- **Advanced**: If you need to proxy DNS, this script currently does not support UDP relay. You would need `dnstc` or `redsocks2` for that.
