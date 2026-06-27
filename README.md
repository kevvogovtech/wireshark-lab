# 🦈 Lab 2 — Wireshark & Network Analysis

> **Certification Alignment:** CompTIA Network+ · Security+ · CySA+  
> **Estimated Time:** 2–4 hours · **Cost:** $0 (Wireshark is free forever)  
> **Career Relevance:** Network Engineer · SOC Analyst · Cloud Security Engineer · Incident Responder

---

## What This Lab Teaches

Wireshark is the industry standard tool for capturing and inspecting network traffic. This lab walks you through real packet analysis — the same skills used daily by SOC analysts, network engineers, and incident responders.

| Skill | Real-World Application |
|---|---|
| Capture live traffic | The foundational skill — you can't analyze what you can't see |
| Apply display filters | Production captures have millions of packets; filters find the 10 that matter |
| Read TCP handshakes | Instantly know whether a connection succeeded or failed |
| Identify DNS queries | DNS is involved in every network action — understand it deeply |
| Spot cleartext credentials | See exactly why HTTPS is non-negotiable |
| Follow TCP streams | Reconstruct full conversations from individual packets |

---

## Repository Structure

```
wireshark-lab/
├── README.md                  ← You are here
├── SETUP.md                   ← Installation guide for all operating systems
├── exercises/
│   ├── A-dns-lookup.md        ← Exercise A: Capture a DNS Lookup
│   ├── B-tcp-handshake.md     ← Exercise B: Watch the TCP Three-Way Handshake
│   ├── C-cleartext-http.md    ← Exercise C: Spot Cleartext Credentials
│   └── D-tcp-stream.md        ← Exercise D: Follow a Full TCP Stream
├── captures/
│   ├── README.md              ← What each .pcapng file contains
│   ├── dns-lookup.pcapng      ← (add your capture here)
│   ├── tcp-handshake.pcapng   ← (add your capture here)
│   └── tcp-stream.pcapng      ← (add your capture here)
├── screenshots/
│   └── README.md              ← Add annotated screenshots here
└── FILTERS.md                 ← Quick reference for Wireshark display filters
```

---

## Key Concepts

### What is a Packet?
A packet is a small unit of data that travels across a network. When you load a web page, the data gets broken into hundreds of packets — each with a **header** (source IP, destination IP, port) and a **payload** (the actual data). Wireshark captures and shows every individual packet.

### The TCP Three-Way Handshake
Before two machines exchange data, they run a 3-step setup:

```
Your Machine          Server
     │                  │
     │──── SYN ────────▶│   "I want to connect"
     │                  │
     │◀─── SYN-ACK ─────│   "Got it. Connection accepted"
     │                  │
     │──── ACK ────────▶│   "Confirmed. Ready to send data"
     │                  │
     ◀══════ DATA ══════▶   Connection is open
```

> 🔴 **SYN with no SYN-ACK** = connection refused or server unreachable  
> 🔴 **RST packet** = connection forcibly closed

### DNS — Domain Name System
Every website visit starts with a DNS query: *"What is the IP address for google.com?"*  
If DNS is broken, **nothing works** — websites, apps, email, databases.

### HTTP vs HTTPS
| | HTTP | HTTPS |
|---|---|---|
| Encryption | ❌ None | ✅ TLS encrypted |
| Credentials visible in Wireshark | ✅ Yes, in plaintext | ❌ No |
| Safe for login forms | ❌ Never | ✅ Required |

---

## Quick Start

```bash
# 1. Install Wireshark (Ubuntu/Debian)
sudo apt install wireshark
sudo usermod -aG wireshark $USER
# Log out and back in, then verify:
wireshark --version

# 2. Command-line capture with tshark (for remote servers)
tshark -i eth0 -w capture.pcapng -c 1000
```

See [SETUP.md](./SETUP.md) for Windows and macOS instructions.

---

## Exercises Overview

| # | Exercise | Skill |
|---|---|---|
| A | [DNS Lookup](./exercises/A-dns-lookup.md) | See how every domain name gets resolved to an IP |
| B | [TCP Handshake](./exercises/B-tcp-handshake.md) | Watch a connection open step by step |
| C | [Cleartext HTTP](./exercises/C-cleartext-http.md) | See credentials in plaintext — why HTTPS matters |
| D | [TCP Stream](./exercises/D-tcp-stream.md) | Reconstruct a full conversation from packets |

---

## Saves & Portfolio

```
File → Save As → .pcapng format        (save full captures)
File → Export Specified Packets        (export only filtered packets)
File → Open → select .pcapng file     (reload saved captures)
```

All `.pcapng` files in `captures/` are intentionally created in a controlled local environment for educational purposes.

---

## ⚠️ Legal & Ethical Notice

> Only capture traffic on networks and systems you own or have **explicit written permission** to analyze.  
> The HTTP credential exercise must only be performed against local test systems.  
> Never use these techniques against systems or networks you do not own.

---

*Lab 2 of the Network Analysis series · Tools used: Wireshark (free, open source)*
