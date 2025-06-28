#!/bin/bash

kernel_release=$(uname -r)


os_version="$(lsb_release -d -s | awk 'NR==1 {print $1 "-" $2 "-" $3}')"
