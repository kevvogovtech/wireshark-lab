# Captures

This folder contains `.pcapng` packet capture files generated during the lab exercises.

## Files

| File | Exercise | What It Shows |
|---|---|---|
| `dns-lookup.pcapng` | Exercise A | DNS query and response for google.com — includes A record with resolved IP |
| `tcp-handshake.pcapng` | Exercise B | Full three-way handshake (SYN → SYN-ACK → ACK) with example.com |
| `cleartext-http.pcapng` | Exercise C | HTTP POST request with credentials visible in plaintext |
| `tcp-stream.pcapng` | Exercise D | Full HTTP conversation reconstructed from individual packets |

## How to Open

1. Install Wireshark (see [SETUP.md](../SETUP.md))
2. `File → Open → select the .pcapng file`
3. All packets will load — apply any display filter from [FILTERS.md](../FILTERS.md)

## Capture Details

All captures were created in a **controlled local environment** for educational purposes:
- Captures involve only traffic from my own machine
- HTTP credential capture used a local test server only
- No third-party credentials or private data are contained in any capture file

## Opening in tshark (Command Line)

```bash
# Read a capture and show all packets
tshark -r dns-lookup.pcapng

# Apply a display filter
tshark -r dns-lookup.pcapng -Y "dns"

# Show packet details
tshark -r tcp-handshake.pcapng -V | head -100
```
