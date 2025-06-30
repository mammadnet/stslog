#!/bin/bash

log_file_path="/var/log/status.log"
data_fetcher="data_fetcher.sh"

script_path=$(readlink -f "$0")
script_directory=$(realpath $(dirname "$script_path"))


("$script_directory/$data_fetcher") | awk '{
for (i=4; i<=NF; i++){
    if (i == 4)
        printf "%s", $i
    else if ($i == "MB")
        printf "MB";
    else
        printf "\n%s", $i;
    }
    printf "\n"
}'