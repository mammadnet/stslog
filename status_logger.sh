#!/bin/bash

kernel_release=$(uname -r)


os_version=$(lsb_release -d -s | awk 'NR==1 {print $1 "-" $2 "-" $3}')

online_users=$(who | awk '{print $1}' | sort | uniq -c | awk '{printf "%s:%s", $2,$1}')

cpu_usage=$(top -bn2 | grep '%Cpu' | tail -1 | awk '{print 100-$8}')

load_average=$(uptime | awk '{print $(NF-2) $(NF-1) $NF}')

cpu_status="$cpu_usage,$load_average"

memory_usage=$(cat /proc/meminfo | grep -P '(MemTotal|MemFree)' | awk '{printf "%s ", $2}' | awk '{print $2/1000 "/" $1/1000 " MB"}')

swap_usage=$(cat /proc/meminfo | grep -P '(SwapTotal|SwapFree)' | awk '{printf "%s ", $2}' | awk '{print $2/1000 "/" $1/1000 " MB"}')

time_stamp=$(date +"%Y-%m-%d %H:%M:%S %z")
