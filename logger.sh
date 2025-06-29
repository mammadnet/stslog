#!/bin/bash

log_file_path="/var/log/status.log"
data_fetcher="data_fetcher.sh"

if [[ ! -f /var/log/status.log ]]; then
    touch "$log_file_path"
fi

script_directory=$(dirname "$0")


"$script_directory/$data_fetcher" >> $log_file_path