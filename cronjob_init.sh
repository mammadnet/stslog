#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0: Permission denied"
    echo "$0: Try with ROOT user"
    exit 1
fi

file_directory=$(realpath $1)
logger_path="$file_directory/logger.sh"

if [[ ! -e $logger_path ]]; then
    echo "Logger path not exist in $logger_path"
    exit 1
fi

$file_directory/cronjob_set.sh -e m5 $file_directory/logger.sh


