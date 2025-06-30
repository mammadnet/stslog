#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0: Permission denied"
    echo "$0: Try with ROOT user"
    exit 1
fi

logger_path=$1

if [[ ! -e $logger_path ]]; then
    echo "Logger path not exist in $logger_path"
    exit 1
fi

(crontab -l 2>/dev/null; echo "*/5 * * * * $logger_path") | crontab -


