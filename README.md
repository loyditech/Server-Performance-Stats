# Server-Performance-Stats

A lightweight Bash script that generates a comprehensive real-time health report for any Linux server. Covering CPU, memory, disk, processes, and security.

## ✨ Features
 
| Section | What it checks |
|---|---|
| System Info | 🖥️ OS, kernel version, architecture, uptime, load average |
| CPU Usage | ⚡ Usage percentage with visual progress bar |
| Memory | 💾 RAM and swap — used, free, available |
| Disk Usage | 💿 All mounted filesystems with color-coded usage alerts |
| Top Processes | 🔥 Top 5 by CPU and top 5 by memory |
| Logged-in Users | 👥 Active sessions and login details |
| Security | 🔐 Failed SSH login attempts and top offending IPs |
 
---
 
## 🚀 Quick Start
 
**1. Clone the repo**
```bash
git clone https://github.com/loyditech/Server-Performance-Stats.git
cd Server-Performance-Stats
```
 
**2. Make executable**
```bash
chmod +x server-stats.sh
```
 
**3. Run**
```bash
./server-stats.sh
```
 
**4. For failed login stats, run with sudo**
```bash
sudo ./server-stats.sh
```
 
---
 
## 🎨 Output
 
### Color-coded disk and memory usage
- 🟢 **Green** — Normal (< 70%)
- 🟡 **Yellow** — Warning (70–89%)
- 🔴 **Red** — Critical (≥ 90%)
### Security — Failed SSH Logins
Reads from `/var/log/auth.log` (Debian/Ubuntu) or `/var/log/secure` (RHEL/CentOS) and surfaces:
- Total failed SSH login attempts
- Top 5 offending IP addresses
---
 
## 📋 Requirements
 
- Linux (Ubuntu, Debian, CentOS, RHEL, or any distro)
- Bash 4.0+
- Standard utilities: `top`, `free`, `df`, `ps`, `who`, `awk`, `grep`
No external dependencies — works on any fresh Linux server out of the box.
 
---
 
## 🔧 Automate with Cron
 
Run every hour and save output to a log file:
 
```bash
# Open crontab
crontab -e
 
# Add this line
0 * * * * /path/to/server-stats.sh >> /var/log/server-stats.log 2>&1
```
 
---
 
## 👤 Author
 
**Mark John Lloyd Ncinas**
- GitHub: [@loyditech](https://github.com/loyditech)
---
 
## 📄 License
 
MIT License — free to use, modify, and distribute.
