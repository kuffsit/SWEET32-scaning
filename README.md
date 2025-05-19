

---

````markdown
# SWEET32 Subdomain Vulnerability Scanner

This script automates the discovery of subdomains for given root domains and checks each subdomain for the SWEET32 vulnerability (CVE-2016-2183) using `nmap`.

## 🧠 What is SWEET32?

SWEET32 is a cryptographic vulnerability that affects block ciphers with 64-bit blocks, such as 3DES. Servers supporting these ciphers in SSL/TLS connections are vulnerable to collision attacks and potential session data decryption.

---

## 📦 Requirements

Make sure the following tools are installed and available in your `PATH`:

- [`nmap`](https://nmap.org/) — for SSL/TLS cipher detection  
- [`subfinder`](https://github.com/projectdiscovery/subfinder) — for subdomain enumeration  
- Bash (Linux/macOS)

### Installation

```bash
sudo apt install nmap -y
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
````

If using `go install`, make sure `$GOPATH/bin` is in your `$PATH`:

```bash
export PATH=$PATH:$(go env GOPATH)/bin
```

---

## 📄 Input Format

Create a text file (e.g. `domains.txt`) with one root domain per line:

```
uzum.uz
uzum.com
daymarket.uz
```

---

## 🚀 Usage

1. Make the script executable:

   ```bash
   chmod +x sweet32_scan.sh
   ```

2. Run the script:

   ```bash
   ./sweet32_scan.sh
   ```

3. Enter:

   * Path to your root domain list file (e.g., `domains.txt`)
   * Port number to scan (default is `443`)

---

## 🧪 Example Output

```
Subdomain                          | Port Status    | SWEET32 Status
-----------------------------------------------------------------------
api.example.com                        | open           | VULNERABLE to SWEET32
store.example.com                       | open           | No Vulnerability
payments.example.com                  | closed         | Not Tested
```

* **"VULNERABLE to SWEET32"** means the server supports 64-bit block ciphers (like 3DES)
* **"No Vulnerability"** means the server does not support weak ciphers
* **"Not Tested"** means the port is closed or filtered

---

## 🗑 Temporary Files

The script automatically creates and removes temporary files used for processing subdomains.

---

## 🛡 Disclaimer

This tool is intended for **educational and authorized testing purposes only**. Do **not** use it against systems without explicit permission.

---


