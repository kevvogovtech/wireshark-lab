# Wireshark Display Filter Reference

> **Display filters** are applied *after* capturing — they never discard data, just hide it.  
> Type in the filter bar at the top of Wireshark and press Enter.

---

## Protocol Filters

| Filter | What It Shows |
|---|---|
| `dns` | All DNS queries and responses |
| `http` | Unencrypted HTTP traffic only |
| `tcp` | All TCP traffic |
| `udp` | All UDP traffic |
| `icmp` | Ping and network diagnostics |
| `tls` | Encrypted TLS/HTTPS traffic |
| `arp` | ARP requests and replies |
| `dhcp` | DHCP lease requests and responses |

---

## TCP Flag Filters

| Filter | What It Shows |
|---|---|
| `tcp.flags.syn == 1` | SYN packets — connection attempts |
| `tcp.flags.ack == 1` | ACK packets — acknowledgements |
| `tcp.flags.reset == 1` | RST packets — forcibly closed connections |
| `tcp.flags.fin == 1` | FIN packets — graceful connection close |
| `tcp.flags.syn == 1 and tcp.flags.ack == 0` | Only SYN (not SYN-ACK) — pure connection attempts |

---

## IP Address Filters

| Filter | What It Shows |
|---|---|
| `ip.addr == 192.168.1.1` | All traffic to OR from this IP |
| `ip.src == 10.0.0.5` | Traffic FROM this IP only |
| `ip.dst == 10.0.0.5` | Traffic TO this IP only |
| `ip.addr == 192.168.1.0/24` | All traffic within this subnet |

---

## Port Filters

| Filter | What It Shows |
|---|---|
| `tcp.port == 443` | HTTPS traffic (by port) |
| `tcp.port == 80` | HTTP traffic (by port) |
| `tcp.port == 22` | SSH traffic |
| `tcp.port == 53` | DNS over TCP |
| `udp.port == 53` | DNS over UDP (most common) |
| `tcp.dstport == 443` | Traffic going TO port 443 |

---

## HTTP Filters

| Filter | What It Shows |
|---|---|
| `http.request` | All HTTP GET and POST requests |
| `http.request.method == "POST"` | POST requests only (form submissions) |
| `http.request.method == "GET"` | GET requests only |
| `http.response.code == 200` | Successful HTTP responses |
| `http.response.code == 404` | Not Found responses |
| `http.host == "example.com"` | HTTP traffic to a specific host |

---

## DNS Filters

| Filter | What It Shows |
|---|---|
| `dns.qry.name == "google.com"` | DNS queries for a specific domain |
| `dns.flags.response == 0` | DNS queries only (not responses) |
| `dns.flags.response == 1` | DNS responses only |
| `dns.resp.name == "google.com"` | DNS responses for a specific domain |

---

## Combining Filters

Use `and`, `or`, and `not` to combine filters:

```
# DNS or ICMP
dns or icmp

# TCP traffic to or from a specific IP
tcp and ip.addr == 192.168.1.1

# HTTP POST requests only
http and tcp.port == 80 and http.request.method == "POST"

# All traffic EXCEPT your own machine
not ip.addr == 192.168.1.100

# SYN packets to port 443 (HTTPS connection attempts)
tcp.flags.syn == 1 and tcp.dstport == 443
```

---

## Useful Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl + F` | Find a packet |
| `Ctrl + /` | Go to packet number |
| `Ctrl + E` | Edit capture filter |
| `Ctrl + Shift + E` | Export specified packets |
| `Ctrl + S` | Save capture |
| `Ctrl + Z` | Undo |
| `Space` | Scroll to next packet |
