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
    # TODO Show help text for stslog command
    echo help text for stslog command
}

if [[ -z $1 ]]; then
    show_current_status
fi

while getopts ":e:sch" opt; do

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
        h)
            help
            ;;
        \?)
            help
            exit 1
            ;;
    esac    

done
