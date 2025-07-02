#!/bin/bash

cron_set() {
    time=$1
    script_path=$2
    cycle=${time:0:1}
    num=${time:1}
    case $cycle in
    m)
        if [[ ($num -gt 59) || ($num -lt 1) ]]; then
            echo "Minute number must be between 1 and 59"
            return 1
        fi
        new_cronjob="*/$num * * * * $script_path"
        ;;
    h)
        if [[ ($num -gt 23) || ($num -lt 1) ]]; then
            echo "Hour number must be between 1 and 24"
            return 1
        fi
        new_cronjob="* */$num * * * $script_path"
        ;;
    d)
        if [[ ($num -gt 30) || ($num -lt 1) ]]; then
        echo $time
            echo "Day number must be between 1 and 30"
            return 1
        fi
        new_cronjob="* * */$num * * $script_path"

        ;;
    M)
        if [[ ($num -gt 12) || ($num -lt 1) ]]; then
            echo "Month number must be between 1 and 12"
            return 1
        fi
        new_cronjob="* * * */$num * $script_path"
        ;;
    \?)
        help
        ;;
    esac

    if [[ ! -z $new_cronjob ]]; then
        cronjobs=$(crontab -l 2>/dev/null | awk -v script="$script_path" '{if ($NF != script ) print $0}')
        (echo "$cronjobs"; echo "$new_cronjob") | crontab -
    fi
}

current_cycle() {
    script_path=$1
    cron_time=$(crontab -l 2>/dev/null | awk -v script="$script_path" '{if ($NF == script ) print $0}')
    cycle_time=$(echo "$cron_time" | awk '{
        for (i=1; i<NF; i++){
            if ($i != "*"){
                num=substr($i, 3)
                if (i == 1)
                    printf "%s Minute", num
                else if (i == 2)
                    printf "%s Hour", num
                else if (i == 3)
                    printf "%s Day", num
                else if (i == 4)
                    printf "%s Month", num
                print ""

            }
        }
    }')
    echo "Log system status every <$cycle_time>"
    
}

help() {
    cat <<-EOF
    
Usage: stslog [OPTIONS] SCRIPT_PATH

Manage the cron job that invokes logger.

OPTIONS:
    -e INTERVAL       Set a new cron entry for the given SCRIPT_PATH.
                    INTERVAL format:
                        mN   every N minutes   (1-59)
                        hN   every N hours     (1-24)
                        dN   every N days      (1-30)
                        MN   every N months    (1-12)
                    Example:
                        stslog -e m5 /opt/stslog/logger.sh

    -c                Show the current cron entry for the given SCRIPT_PATH.
    -h                Show this help message and exit.

EOF
}



script_path=${@: -1}

if [[ -z $script_path ]]; then
    echo Script path not entered
    exit 1
else
    if [[ ! -e $script_path ]]; then
        echo "$script_path not exist, enter the correct path"
        exit 1
    fi
fi

while getopts ":e:ch" opt; do

    case $opt in

        e) 
            cron_set "$OPTARG" "$script_path"
            if [[ $? -ne 0 ]]; then
                echo Cronjob set not successful
                exit 1
            fi
            ;;
        
        c)
            current_cycle $script_path
            ;;
        
        h)
            help
            ;;

        \?)
            echo Not option set
            ;;
        :)
            echo Not option set
            ;;
        *)
            echo Not option set
            ;;
    esac
done