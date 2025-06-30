#!/bin/bash

kernel_release=$(uname -r)

# name-version-type
os_version=$(lsb_release -d -s | awk 'NR==1 {print $1 "-" $2 "-" $3}')

# Username:number of sessions
online_users=$(who | awk '{print $1}' | sort | uniq -c | awk '{printf "%s:%s", $2,$1}')

# Persentage of CPU usage
cpu_usage=$(top -bn2 | grep '%Cpu' | tail -1 | awk '{print 100-$8}')

# For last 1Min,5Min,15Min
load_average=$(uptime | awk '{print $(NF-2) $(NF-1) $NF}')

cpu_status="$cpu_usage,$load_average"

memory_usage=$(cat /proc/meminfo | grep -P '(MemTotal|MemFree)' | awk '{printf "%s ", $2}' | awk '{print $2/1000 "/" $1/1000 " MB"}')

swap_usage=$(cat /proc/meminfo | grep -P '(SwapTotal|SwapFree)' | awk '{printf "%s ", $2}' | awk '{print $2/1000 "/" $1/1000 " MB"}')

# Year:Month:day Hour:Minut:Seconds Sone
time_stamp=$(date +"%Y-%m-%d %H:%M:%S %z")

formated_log="[$time_stamp] Kernel:$kernel_release OS:$os_version Users:[$online_users] CPU:$cpu_status Memory:$memory_usage Swap:$swap_usage"

echo $formated_log