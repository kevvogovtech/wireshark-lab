# Setup Guide — Installing Wireshark

Wireshark is completely free and open source. No account, no trial, no licence required.

Download from: **https://wireshark.org/download.html**

---

## Windows

1. Download **Windows x64 Installer (.exe)**
2. Run the installer — accept all defaults
3. When prompted to install **Npcap**, say yes — this is required to capture packets
4. Verify installation:
```cmd
wireshark --version
```

---

## macOS

1. Download **macOS Arm or Intel (.dmg)** depending on your chip
2. Run the installer
3. If prompted about **ChmodBPF** — allow it (this lets Wireshark access network interfaces)
4. Verify:
```bash
wireshark --version
```

---

## Linux (Ubuntu / Debian)

```bash
# Install Wireshark
sudo apt update
sudo apt install wireshark -y

# Add yourself to the wireshark group so you can capture without root
sudo usermod -aG wireshark $USER

# Log out and back in, then verify
wireshark --version
```

For other distros:
```bash
# Fedora / RHEL
sudo dnf install wireshark

# Arch
sudo pacman -S wireshark-qt
```

---

## Verify Everything Works

1. Open Wireshark
2. You should see a list of network interfaces with live traffic waveforms
3. Double-click your active interface (Ethernet or Wi-Fi — whichever shows movement)
4. Packets should start appearing immediately
5. Click the red square **Stop** button
6. You have a working capture setup ✅

---

## Optional: tshark (Command-Line Wireshark)

`tshark` is included with Wireshark and useful for capturing on remote servers without a GUI.

```bash
# Capture 1000 packets on eth0 and save to a file
tshark -i eth0 -w capture.pcapng -c 1000

# Capture only DNS traffic
tshark -i eth0 -f "port 53" -w dns-capture.pcapng

# Read an existing capture file
tshark -r capture.pcapng

# Apply a display filter when reading
tshark -r capture.pcapng -Y "dns"
```
