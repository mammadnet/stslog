#!/bin/bash

kernel_release=$(uname -r)


os_version="$(lsb_release -d -s | awk 'NR==1 {print $1 "-" $2 "-" $3}')"

online_users=$(who | awk '{print $1}' | sort | uniq -c | awk '{printf "%s:%s", $2,$1}')