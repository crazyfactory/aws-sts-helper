#!/bin/bash

set -eE

STRING=$(cat ~/.aws/config)

# Use multi step sed, not grep to avoid utf8 bash issues across operating systems.

# Get list of profiles

# Create array - requires bash 4
while IFS= read -r line; do
    PROFILE_LIST+=("$line")
    echo $line
done <<< "$(aws configure list-profiles)"
unset IFS

for PROFILE in "${PROFILE_LIST[@]}"
do
    PROFILE="$(echo $PROFILE | sed 's~[^[:alnum:]_]\+~~g')"

    if [[ "$PROFILE" != *"_temp"* ]]; then
        CLEANED_PROFILE_LIST+=( "${PROFILE}" )
    fi
done

IFS=$'\n' CLEANED_PROFILE_LIST=($(sort <<< "${CLEANED_PROFILE_LIST[*]}"))
unset IFS

PS3='Please enter your choice: '
select PROFILE in "${CLEANED_PROFILE_LIST[@]}"
do
    export PROFILE
    break
done
