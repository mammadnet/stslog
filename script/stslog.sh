#!/bin/bash

log_file_path="/var/log/status.log"
data_fetcher="data_fetcher.sh"

script_path=$(readlink -f "$0")
script_directory=$(realpath $(dirname "$script_path"))

show_current_status() {

    ("$script_directory/$data_fetcher") | awk '{
    for (i=4; i<=NF; i++){
        if (i == 4)
            printf "%s", $i
        else if ($i == "MB")
            printf " MB";
        else
            printf "\n%s", $i;
        }
        printf "\n"
    }'
    return 0
}

help() {
    cat <<-EOF
Usage: stslog [OPTIONS]

A system status logger.

OPTIONS:
    -s                Show current system status (same as no args).
    -e INTERVAL       Configure automatic logging interval.
                    INTERVAL format:
                        mN   every N minutes   (1-59)
                        hN   every N hours     (1-24)
                        dN   every N days      (1-30)
                        MN   every N months    (1-12)
                    Example: stslog -e m15

    -c                Display the current cron schedule for logger.sh.
    -l                Show all logged entries from /var/log/status.log.
    -d "START/END"    Show logs between two timestamps.
                    START/END format:
                        "YYYY-MM-DD HH:MM/YYYY-MM-DD HH:MM"
                    Example:
                        stslog -d "2025-07-01 00:00/2025-07-02 12:00"

    -h                Show this help message and exit.

Without any options, stslog will display the current status.
EOF
}


if [[ -z $1 ]]; then
    show_current_status
fi

while getopts ":e:scld:h" opt; do

    case $opt in 

        s)
            show_current_status
            ;;
        e)
            if [[ ! $EUID -eq 0 ]]; then
                echo This operation requires ROOT permission
                exit 1
            fi
            $script_directory/cronjob_set.sh -e $OPTARG $script_directory/logger.sh
            
            if [[ ! $? -eq 0 ]]; then
                exit 1
            fi
            ;;
        
        c)
            $script_directory/cronjob_set.sh -c $script_directory/logger.sh
            ;;
        
        l)
            $script_directory/show_logs.sh -l $log_file_path
            ;;
        d)
            $script_directory/show_logs.sh -d "$OPTARG" $log_file_path
            ;;
        h)
            help
            ;;
        \?)
            help
            exit 1
            ;;
    esac    

done
