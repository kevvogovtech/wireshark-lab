# Exercise D — Follow a Full TCP Stream

**Goal:** Reassemble an entire HTTP conversation from individual packets using Wireshark's Follow TCP Stream feature.

**Time:** ~15 minutes  
**Skill:** Stream reconstruction, incident investigation technique

---

## Background

Individual packets are fragments. A single HTTP request to load a web page might be spread across dozens of packets. The **Follow TCP Stream** feature in Wireshark reassembles all the packets from a single connection into a readable conversation — showing you exactly what was sent and received, in order.

This is the technique incident responders use to reconstruct what happened during a network event:
- What data was transferred?
- What commands were sent?
- What did the server respond with?
- Was any sensitive data exfiltrated?

---

## Stream View Colors

| Color | Meaning |
|---|---|
| 🔴 Red text | Data sent **from your machine** (the request) |
| 🔵 Blue text | Data received **from the server** (the response) |

---

## Steps

### 1. Capture HTTP traffic
- Open Wireshark → start a capture on your active interface
- Open a browser and go to `http://example.com`
- Wait for the page to fully load
- Stop the capture

### 2. Apply the HTTP filter
```
http
```

### 3. Right-click and Follow the stream
- Right-click any HTTP packet in the list
- Select **Follow → TCP Stream**

A new window opens showing the full reconstructed conversation.

### 4. Read the conversation

You should see something like this:

**Red (your browser's request):**
```
GET / HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0 ...
Accept: text/html,application/xhtml+xml,...
Accept-Language: en-US,en;q=0.9
Connection: keep-alive
```

**Blue (server's response):**
```
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Content-Length: 1256
...

<!doctype html>
<html>
<head>
    <title>Example Domain</title>
...
```

---

## What to Analyze

While looking at the stream, answer these questions:

1. **What HTTP method was used?** (GET, POST, PUT...)
2. **What is the `Host` header?** (confirms which server was contacted)
3. **What `User-Agent` did your browser send?** (browser and OS fingerprinting)
4. **What was the HTTP response code?** (200 OK, 301 Redirect, 404 Not Found...)
5. **What `Content-Type` did the server return?** (HTML, JSON, image...)
6. **Can you read the actual page content** in the response body?

---

## Stream Controls

In the Follow TCP Stream window:

| Control | What it does |
|---|---|
| **Show data as** dropdown | Switch between ASCII, Hex, C Arrays |
| **Stream selector** | Jump between different TCP streams in the capture |
| **Find** | Search for specific text in the stream |
| **Save As** | Export the raw stream content to a file |

---

## Optional: Compare HTTP vs HTTPS Streams

Try following a stream from an HTTPS site:
```
tcp.port == 443
```
Right-click a TLS packet → Follow → TCP Stream

You will see encrypted binary data instead of readable text. This shows the practical difference between HTTP and HTTPS at the packet level.

---

## Incident Investigation Context

In a real investigation, following TCP streams lets you:

> "We see an alert for data exfiltration. Filter for traffic to the suspicious IP, follow the TCP stream — we can see exactly what files were transferred and when."

> "A user reports their credentials were stolen. Find the POST request, follow the stream, see the login form data and the server's response."

> "An unknown process is making outbound connections. Find the stream, read what it's sending — is it command-and-control traffic?"

---

## Save Your Capture

```
File → Save As → tcp-stream.pcapng
```

From the Follow TCP Stream window, you can also:
```
Save As → stream-content.txt
```

Move both to the `captures/` folder.

---

## Verification Checklist

- [ ] Captured HTTP traffic from an HTTP (not HTTPS) site
- [ ] Applied `http` display filter
- [ ] Right-clicked a packet and selected Follow → TCP Stream
- [ ] Identified the red (request) and blue (response) sections
- [ ] Read the full HTTP request headers
- [ ] Read the full HTTP response including the HTML body
- [ ] Answered the 6 analysis questions above
- [ ] Attempted the same on an HTTPS stream — confirmed it is unreadable
- [ ] Saved capture as `captures/tcp-stream.pcapng`
