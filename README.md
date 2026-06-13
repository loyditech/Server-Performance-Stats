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

## ⚙️ Automated Monitoring (Cron)

Use the included `run-stats.sh` wrapper to run automatically every 5 minutes and save timestamped reports.

**1. Make executable**
```bash
chmod +x run-stats.sh
```

**2. Add to crontab**
```bash
crontab -e
```

**3. Add this line**
```bash
*/5 * * * * /bin/bash /path/to/server-stats/run-stats.sh
```

Reports are saved to `~/logs/server-stats/` with timestamps. Only the last 12 reports are kept (1 hour of history).

---

## 📁 Project Structure

```
Server-Performance-Stats/
├── server-stats.sh     # Main monitoring script
├── run-stats.sh        # Cron wrapper — automated scheduling + log rotation
└── README.md           # This file
```

---

## 🗺️ Roadmap

- [x] CPU, memory, disk usage reporting
- [x] Top 5 processes by CPU and memory
- [x] Failed SSH login detection with IP tracking
- [x] Color-coded output with visual progress bars
- [x] Automated cron scheduling with log rotation
- [ ] Email alerts when thresholds exceeded
- [ ] JSON output mode for monitoring tool integration
- [ ] AWS CloudWatch integration

---

## 👤 Author

**Mark John Lloyd Ncinas**
- GitHub: [@loyditech](https://github.com/loyditech)

---

## 📄 License

MIT License — free to use, modify, and distribute.
