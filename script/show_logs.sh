#!/bin/bash

all_logs() {
    log_path=$1
    if [[ ! -e $log_path ]]; then
        echo Log file not found
        return 1
    fi

    less $log_path
}

log_path=${@: -1}

while getopts ":ld:h" opts; do
    case $opts in

        l)
            all_logs $log_path
            ;;
        d)
            echo show logs by start date and time
            ;;
        \?)
            echo wrong options
            ;;

    esac
done