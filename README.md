# Server-Performance-Stats

A lightweight Bash script that generates a comprehensive real-time health report for any Linux server — covering CPU, memory, disk, processes, and security.

Features
Section           What it checks
System            InfoOS, kernel version, architecture, uptime, load average
⚡ CPU            UsageUsage percentage with visual progress bar
💾 Memory         RAM and swap — used, free, available
💿 Disk           UsageAll mounted filesystems with color-coded usage alerts
🔥 Top Processes  Top 5 by CPU and top 5 by memory
👥 Logged-in      UsersActive sessions and login details
🔐 Security       Failed SSH login attempts and top offending IPs

🚀 Quick Start

1. Clone the repo
bashgit clone https://github.com/loyditech/Server-Performance-Stats.git
cd Server-Performance-Stats

3. Make executable
bashchmod +x server-stats.sh

4. Run
bash./server-stats.sh

5. For failed login stats, run with sudo
bashsudo ./server-stats.sh

🎨 Output
Color-coded disk and memory usage

🟢 Green — Normal (< 70%)
🟡 Yellow — Warning (70–89%)
🔴 Red — Critical (≥ 90%)

Security — Failed SSH Logins
Reads from /var/log/auth.log (Debian/Ubuntu) or /var/log/secure (RHEL/CentOS) and surfaces:

Total failed SSH login attempts
Top 5 offending IP addresses


📋 Requirements

Linux (Ubuntu, Debian, CentOS, RHEL, or any distro)
Bash 4.0+
Standard utilities: top, free, df, ps, who, awk, grep

No external dependencies — works on any fresh Linux server out of the box.

🔧 Automate with Cron
Run every hour and save output to a log file:
bash# Open crontab
crontab -e

# Add this line
0 * * * * /path/to/server-stats.sh >> /var/log/server-stats.log 2>&1

🗺️ Roadmap

 CPU, memory, disk usage reporting
 Top 5 processes by CPU and memory
 Failed SSH login detection with IP tracking
 Color-coded output with visual progress bars
 Email alerts when thresholds exceeded
 JSON output mode for monitoring tool integration
 Docker support for remote host monitoring
 AWS CloudWatch integration


👤 Author
Mark John Lloyd Ncinas
GitHub: @loyditech


📄 License
MIT License — free to use, modify, and distribute.
