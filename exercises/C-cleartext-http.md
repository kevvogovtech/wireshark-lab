# Exercise C — Spot Cleartext Credentials in HTTP

**Goal:** Submit a login form over HTTP and find the username and password in plaintext inside a captured packet.

**Time:** ~20 minutes  
**Skill:** HTTP analysis, understanding why HTTPS is mandatory

---

> ⚠️ **Legal notice:** Only perform this exercise against systems you own or a local test server.  
> Never capture traffic on networks or systems you do not have explicit permission to test.

---

## Background

HTTP transfers data with **zero encryption**. Every character you type into a login form, every piece of data the server returns, travels across the network as readable text. Anyone between you and the server — your router, your ISP, anyone on the same Wi-Fi — can read it exactly as you typed it.

HTTPS adds TLS encryption on top of HTTP. The packet structure is the same, but the payload is encrypted — Wireshark can see the packet exists, but cannot read what is inside it.

**This exercise demonstrates the vulnerability directly.** Seeing credentials in plaintext in Wireshark is how security teams prove this risk to developers and stakeholders who question whether HTTPS is necessary.

---

## Set Up a Local HTTP Test Server

You need a local HTTP login form to capture against. Here are two options:

### Option 1 — Python one-liner (simplest)

Save this as `login.html` in any folder:

```html
<!DOCTYPE html>
<html>
<head><title>Test Login</title></head>
<body>
  <h2>Test Login Form</h2>
  <form method="POST" action="/login">
    <input type="text" name="username" placeholder="Username"><br><br>
    <input type="password" name="password" placeholder="Password"><br><br>
    <button type="submit">Login</button>
  </form>
</body>
</html>
```

Then run a simple Python server in that folder:

```bash
# Python 3
python3 -m http.server 8080

# Windows
python -m http.server 8080
```

Open your browser to: `http://localhost:8080/login.html`

> Note: Python's built-in server doesn't process POST requests — you will still see the POST packet with credentials in Wireshark even if the page doesn't do anything with the submission. That's all we need.

### Option 2 — Use a dedicated test site

Some ethical hacking practice sites offer intentionally vulnerable HTTP login forms. Search for "DVWA" (Damn Vulnerable Web Application) or "OWASP WebGoat" — both are designed for exactly this kind of practice and run locally.

---

## Steps

### 1. Start a capture
Open Wireshark → double-click your loopback interface (`lo` on Linux/Mac, `Loopback` on Windows) if testing locally, or your active network interface.

### 2. Submit the login form
Navigate to your test login form in a browser.  
Enter any test credentials — for example:
- Username: `testuser`
- Password: `hunter2`

Click the Login button.

### 3. Stop the capture
Click the red **Stop** button in Wireshark.

### 4. Apply the filter
```
http.request.method == "POST"
```

### 5. Find the POST packet
Click the POST packet in the list.

In the **packet detail pane**, expand:
```
Hypertext Transfer Protocol
  └── HTML Form URL Encoded
        ├── username: testuser
        └── password: hunter2
```

You will see your credentials in plaintext.

---

## What the Packet Looks Like

```
POST /login HTTP/1.1
Host: localhost:8080
Content-Type: application/x-www-form-urlencoded
Content-Length: 30

username=testuser&password=hunter2
```

The last line — `username=testuser&password=hunter2` — is what an attacker on the same network would see in every unencrypted login submission.

---

## The HTTPS Comparison

Apply this filter to see HTTPS traffic:
```
tcp.port == 443
```

Click a TLS packet. In the packet detail pane you will see:
```
Transport Layer Security
  TLSv1.3 Record Layer: Application Data Protocol
    Encrypted Application Data: 8f4d2a1c...  ← unreadable
```

The payload exists — but it is encrypted. Even with the full packet, there are no credentials to extract.

---

## Why This Matters

| Attack | Requires |
|---|---|
| Man-in-the-Middle on HTTP | Access to the same network (coffee shop, corporate Wi-Fi) |
| ARP spoofing | Same LAN segment |
| ISP interception | No special access required |
| Wireshark on a shared hub | Physical access |

All of these are realistic scenarios. HTTPS eliminates the credential exposure in every one.

---

## Save Your Capture

```
File → Save As → cleartext-http.pcapng
```

Move to `captures/`. Include a screenshot showing the credentials visible in the packet detail pane in your `screenshots/` folder.

---

## Verification Checklist

- [ ] Set up a local HTTP test server
- [ ] Submitted a test login form over HTTP (not HTTPS)
- [ ] Applied `http.request.method == "POST"` filter
- [ ] Found the POST packet
- [ ] Located the credentials in the HTML Form URL Encoded section
- [ ] Compared against an HTTPS packet — confirmed payload is encrypted
- [ ] Saved capture as `captures/cleartext-http.pcapng`
