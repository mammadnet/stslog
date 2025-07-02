# stslog: System Status Logger

**Fully written in Bash.**

`stslog` is a simple system status logger written in Bash. It periodically collects and logs system metrics such as kernel version, OS version, number of logged-in users, CPU usage, memory and swap usage, and more. You can view the current status on demand, configure logging intervals, and review historical logs.

## Features

* **On-Demand Status**: Run `stslog` without arguments or with `-s` to display the latest system status.
* **Automatic Logging**: Set up a cron job to log status at regular intervals.
* **Custom Schedule**: Use `-e` with minute (`m`), hour (`h`), day (`d`), or month (`M`) intervals (e.g., `m5` for every 5 minutes).
* **Cron Management**: View the current cron schedule with `-c`.
* **Log Review**: Display all logs (`-l`) or logs within a date range (`-d "start/end"`).

## Prerequisites

* **Root privileges**: Installation and scheduling require root.
* **Bash**: The scripts are written for Bash.
* **cron**: To schedule periodic logging.
* **lsb\_release** (from `lsb-release` package): For OS version information.

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/mammadnet/stslog.git
   cd stslog
   ```

2. **Install**:

   ```bash
   sudo ./install.sh
   ```

   This will:

   * Create `/opt/stslog`
   * Copy all scripts into `/opt/stslog`
   * Set up a default cron job logging every 5 minutes
   * Create a symlink `/bin/stslog` for easy access

3. **Verify**:

   ```bash
   which stslog
   # /bin/stslog
   ```

## Usage

### Display Current Status

```bash
stslog
# or
stslog -s
```

### Configure Automatic Logging

Set up or update the cron job interval:

```bash
sudo stslog -e <interval>
```

* **Minute interval**: `mN` — every `N` minutes (1–59)
* **Hour interval**: `hN` — every `N` hours (1–24)
* **Day interval**: `dN` — every `N` days (1–30)
* **Month interval**: `MN` — every `N` months (1–12)

Example: Log every 15 minutes:

```bash
sudo stslog -e m15
```

### View Cron Schedule

```bash
stslog -c
```

### Review Logs

* **Show all logs**:

  ```bash
  stslog -l
  ```

* **Show logs within a date range**:

  ```bash
  stslog -d "YYYY-MM-DD HH:MM/YYYY-MM-DD HH:MM"
  ```

  Example:

  ```bash
  stslog -d "2025-07-01 00:00/2025-07-02 12:00"
  ```

## Log File Location

Logs are stored in `/var/log/status.log`:

```
[2025-07-02 14:23:01 +0300] Kernel:5.4.0-81-generic OS:Ubuntu-20.04 LTS Users:[alice:2,bob:1] CPU:12.5,0.03 0.05 0.01 Memory:2048/4096 MB Swap:512/1024 MB
```

Each line contains:

* Timestamp
* Kernel version
* OS description
* Active users with session counts
* CPU usage (%), and load averages (1, 5, 15 min)
* Memory usage (used/total MB)
* Swap usage (used/total MB)

## Uninstallation

To remove `stslog`:

```bash
sudo crontab -l | grep -v /opt/stslog/logger.sh | crontab -
sudo rm /bin/stslog
sudo rm -rf /opt/stslog
sudo rm /var/log/status.log
```

## Contributing

Contributions and improvements are welcome. Feel free to open issues or submit pull requests.

