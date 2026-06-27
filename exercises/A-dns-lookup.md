# Exercise A — Capture a DNS Lookup

**Goal:** Capture a DNS query and response in Wireshark. Identify the A record and confirm the IP address matches what `nslookup` returned.

**Time:** ~15 minutes  
**Skill:** DNS analysis, display filters, reading packet details

---

## Background

Every website visit, API call, and email starts with an invisible DNS lookup. Your machine asks a DNS server: *"What is the IP address for google.com?"* The DNS server replies with an answer. This all happens in milliseconds before any actual data is transferred.

**DNS record types:**
| Type | Number | Purpose |
|---|---|---|
| A | 1 | Maps a domain to an IPv4 address |
| AAAA | 28 | Maps a domain to an IPv6 address |
| MX | 15 | Identifies mail servers for a domain |
| CNAME | 5 | Alias pointing to another domain name |

In this exercise you will see **A record** queries and responses.

---

## Steps

### 1. Start a capture
- Open Wireshark
- Double-click your active network interface (the one with activity in the waveform)
- Packets begin appearing immediately — that is normal

### 2. Trigger a DNS lookup
Open a **separate terminal window** (do not close Wireshark):

```bash
# Windows (Command Prompt)
nslookup google.com

# macOS / Linux (Terminal)
nslookup google.com
```

Expected output:
```
Server:  192.168.1.1
Address:  192.168.1.1#53

Non-authoritative answer:
Name:    google.com
Address: 142.250.80.46
```

Note the IP address returned — you will confirm this in Wireshark.

### 3. Stop the capture
Click the red square **Stop** button in Wireshark.

### 4. Apply the DNS filter
In the filter bar at the top, type:
```
dns
```
Press Enter. The packet list now shows only DNS traffic.

### 5. Find the query packet
Look in the **Info** column for:
```
Standard query 0x#### A google.com
```
This is your machine asking for the A record.

### 6. Find the response packet
Look in the **Info** column for:
```
Standard query response 0x#### A google.com A 142.250.80.46
```
The transaction ID (the hex number) will match the query.

### 7. Inspect the response
Click the DNS response packet to select it. In the **packet detail pane** (middle panel):
1. Click the arrow next to `Domain Name System (response)` to expand it
2. Expand `Answers`
3. You will see the A record with the IP address

✅ **Confirm the IP matches what `nslookup` showed in the terminal.**

---

## What to Look For

```
Frame N: DNS Response
  Transaction ID: 0x1234  ← matches the query packet
  Flags: 0x8180 (Standard query response, No error)
  Questions: 1
  Answers: 1
  └── google.com: type A, class IN
        Name: google.com
        Type: A (1)
        Address: 142.250.80.46  ← the IP your browser uses
```

---

## Why This Matters

> Unusual DNS queries are often the **first sign of malware** on a network.  
> Malware calls home to command-and-control servers using DNS to look up its server addresses.  
> A SOC analyst watching DNS traffic can spot: unusual domain patterns, high query frequency, domains with random-looking names (DGA — Domain Generation Algorithms), or queries to unexpected external DNS servers.

---

## Save Your Capture

```
File → Save As → dns-lookup.pcapng
```

Move the file to the `captures/` folder in this repo.

---

## Verification Checklist

- [ ] Applied `dns` display filter
- [ ] Found the query packet (Standard query A google.com)
- [ ] Found the response packet (Standard query response)
- [ ] Located the A record in the packet detail pane
- [ ] Confirmed the IP matches `nslookup` output
- [ ] Identified the transaction ID linking query to response
- [ ] Saved capture as `captures/dns-lookup.pcapng`
