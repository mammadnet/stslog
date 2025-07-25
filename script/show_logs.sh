#!/bin/bash

all_logs() {
    log_path=$1
    if [[ ! -e $log_path ]]; then
        echo Log file not found
        return 1
    fi

    less $log_path
}

log_by_date() {

    format="$1"
    log_path=$2

    IFS='/' read -r sdate edate <<< "$format"
    if [[ "$edate" =~ ^[0-9]{1,4}-[0-9]{1,2}-[0-9]{1,2}[[:space:]][0-9]{1,2}:[0-9]{1,2}$ ]]; then
        sdate=$(date -d "$sdate" +"%Y-%m-%d %H:%M:%S")
    else
        echo Start date time format invalid
        help
        exit 1
    fi

    if [[ "$edate" =~ ^[0-9]{1,4}-[0-9]{1,2}-[0-9]{1,2}[[:space:]][0-9]{1,2}:[0-9]{1,2}$ ]]; then
        edate=$(date -d "$edate" +"%Y-%m-%d %H:%M:%S")
    else
        echo End date time format invalid
        help
        exit 1
    fi
    echo "$sdate ---> $edate"
    awk -v start="$sdate" -v end="$edate" '{
        log_date=substr($0, 2, 19)
        
        if (log_date >= start && log_date <= end)
            print $0


    }' "$log_path"

}

help() {
    cat <<-EOF

Usage: stslog [OPTIONS]

Display entries from the status log.

OPTIONS:
    -l                Show all log entries (opens in less).
    -d "START/END"    Show entries between two timestamps.
                    START/END format:
                        "YYYY-MM-DD HH:MM/YYYY-MM-DD HH:MM"
                    Example:
                        show_logs.sh -d "2025-07-01 00:00/2025-07-02 12:00" /var/log/status.log

    -h                Show help message and exit.
    
EOF
    
}

log_path=${@: -1}

while getopts ":ld:h" opts; do
    case $opts in

        l)
            all_logs $log_path
            ;;
        d)
            log_by_date "$OPTARG" "$log_path"
            ;;
        \?)
            echo wrong options
            ;;

    esac
done