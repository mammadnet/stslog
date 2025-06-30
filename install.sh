#!/bin/bash

# Check if user is root
if [[ $EUID -ne 0 ]]; then
    echo "$0: Permission denied"
    echo "$0: Try with ROOT user"
    exit 1
fi

file_directory=$(realpath $(dirname "$0"))

target_directory="/opt/stslog"

if [[ ! -d $target_directory ]]; then
    mkdir $target_directory

    echo "File directory created on $target_directory"
fi

cp -r "$file_directory/script/." "$target_directory"

echo "Set cronjob..."
$($file_directory/cronjob_init.sh "$target_directory")
if [[ $? -eq 0 ]]; then
    echo "New cronjob added successful"
else
    echo "Can't add cronjob"
    exit 0
fi

$(ln -f -s "$target_directory/stslog.sh" "/bin/stslog")

echo "status logger installed successfuly..."
echo "Enjoy it :)"




