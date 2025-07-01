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

help() {
    # TODO Print help text for cronjob set
    echo "This is help text for cron job set"

}


script_path=$3

if [[ -z $script_path ]]; then
    echo Script path not entered
    exit 1
else
    if [[ ! -e $script_path ]]; then
        echo "$script_path not exist, enter the correct path"
        exit 1
    fi
fi

while getopts ":e:h" opt; do

    case $opt in

        e) 
            cron_set "$OPTARG" "$script_path"
            if [[ $? -ne 0 ]]; then
                echo Cronjob set not successful
                exit 1
            fi
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