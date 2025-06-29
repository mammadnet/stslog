#!/bin/bash

log_file_path="/var/log/status.log"
data_fetcher="data_fetcher.sh"

if [[ $EUID -ne 0 ]]; then
    echo "$0: Permission denied"
    echo "$0: Try with ROOT user"
    exit 1
fi

if [[ ! -f /var/log/status.log ]]; then
    touch "$log_file_path"
fi

script_directory=$(dirname "$0")


"$script_directory/$data_fetcher" >> $log_file_path