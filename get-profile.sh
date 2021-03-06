#!/bin/bash

set -eE

STRING=$(cat ~/.aws/config)

# Use multi step sed, not grep to avoid utf8 bash issues across operating systems.

# Get list of profiles
STRING=$(sed '/^\(\[profile \|-t\(h\|o\)\)/!d' <<< "${STRING}")
STRING="${STRING//\[profile /}"
STRING="${STRING//\]/}"

# Create array - requires bash 4
readarray -t PROFILE_LIST <<< "${STRING}"

IFS=$'\n' PROFILE_LIST=($(sort <<< "${PROFILE_LIST[*]}"))
unset IFS

PS3='Please enter your choice: '
select PROFILE in "${PROFILE_LIST[@]}"
do
    export PROFILE
    break
done
