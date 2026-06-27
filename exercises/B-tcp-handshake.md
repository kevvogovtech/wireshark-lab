# Exercise B — Watch the TCP Three-Way Handshake

**Goal:** Capture a TCP connection and identify all three packets of the handshake — SYN, SYN-ACK, and ACK.

**Time:** ~20 minutes  
**Skill:** TCP analysis, connection troubleshooting, flag reading

---

## Background

Before two machines can exchange data over TCP, they perform a three-step connection setup. Understanding this handshake is the foundation of network troubleshooting — if a connection fails, the handshake is where you find out why.

```
Your Machine              Server
     │                       │
     │──── SYN ─────────────▶│  "I want to connect. My sequence starts at X."
     │                       │
     │◀─── SYN-ACK ──────────│  "Got it. My sequence starts at Y. Confirm with X+1."
     │                       │
     │──── ACK ─────────────▶│  "Confirmed. Connection open."
     │                       │
     ◀════════ DATA ══════════▶  (data exchange begins)
```

### Failure patterns

| What you see | What it means |
|---|---|
| SYN but no SYN-ACK | Server unreachable, port closed, or firewall blocking |
| SYN then RST | Server actively refused the connection |
| SYN-ACK but no ACK | Connection dropped mid-handshake (rare — network issue) |

---

## Steps

### 1. Get the IP address of the target site
Open a terminal and run:
```bash
nslookup example.com
```
Note the IP address (e.g. `93.184.216.34`).

### 2. Start a capture
- Open Wireshark
- Double-click your active network interface

### 3. Navigate to the target site
Open a browser and go to:
```
http://example.com
```
Use **HTTP**, not HTTPS — the handshake is the same either way, but HTTP makes the subsequent data easier to see.

### 4. Stop the capture
Click the red **Stop** button.

### 5. Apply the filter
Replace the IP below with the one you got from `nslookup`:
```
tcp and ip.addr == 93.184.216.34
```

### 6. Find the three handshake packets
Look for three consecutive packets:

| Order | Info column shows | Flags |
|---|---|---|
| 1st | `[SYN]` | SYN = 1, ACK = 0 |
| 2nd | `[SYN, ACK]` | SYN = 1, ACK = 1 |
| 3rd | `[ACK]` | SYN = 0, ACK = 1 |

### 7. Inspect each packet
Click each of the three packets. In the packet detail pane, expand:
```
Transmission Control Protocol
  └── Flags
        ├── SYN: Set / Not set
        ├── ACK: Set / Not set
        └── ...
```

---

## What to Record

For each of the three packets, note:

**Packet 1 — SYN**
- Source IP: (your machine)
- Destination IP: (server)
- Sequence number: ___________
- SYN flag: Set ✅

**Packet 2 — SYN-ACK**
- Source IP: (server)
- Destination IP: (your machine)
- Sequence number: ___________
- Acknowledgement number: _________ (should be your SYN seq + 1)
- SYN flag: Set ✅  ACK flag: Set ✅

**Packet 3 — ACK**
- Sequence number: ___________
- Acknowledgement number: _________ (should be server SYN seq + 1)
- ACK flag: Set ✅

---

## Additional Filters to Explore

```
# See only connection attempts (SYN without ACK)
tcp.flags.syn == 1 and tcp.flags.ack == 0

# See all connection resets
tcp.flags.reset == 1

# See only the SYN-ACK (server's acceptance)
tcp.flags.syn == 1 and tcp.flags.ack == 1
```

---

## Why This Matters

> When a developer reports "the service is unreachable," or a monitoring alert fires for a failed health check, the **first thing a network engineer does is look at the handshake.**  
> If there is a SYN with no SYN-ACK, the problem is: the wrong IP, a firewall rule, a service not listening on that port, or a routing issue.  
> The handshake tells you immediately where to look next.

---

## Save Your Capture

```
File → Save As → tcp-handshake.pcapng
```

Move the file to the `captures/` folder.

---

## Verification Checklist

- [ ] Applied filter for TCP traffic to/from the target IP
- [ ] Found the SYN packet — identified source, destination, and sequence number
- [ ] Found the SYN-ACK packet — confirmed both flags are set
- [ ] Found the ACK packet — confirmed the handshake completed
- [ ] Can explain what each packet means without looking at notes
- [ ] Saved capture as `captures/tcp-handshake.pcapng`
