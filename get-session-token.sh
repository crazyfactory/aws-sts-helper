#!/bin/bash
set -eE

TEMP_PWD=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source "${TEMP_PWD}/setup.sh"

printf "\nEnter profile: "
read -r PROFILE
if [ -z "${PROFILE}" ]
then
    echo "No profile set.  Exiting."
fi

printf "\nAuthenticating with profile %s." "${PROFILE}"

MFA_SERIAL=$(aws configure --profile "${PROFILE}" get mfa_serial)

printf "\n\nEnter token for %s: " "${MFA_SERIAL}"
read -r TOKEN
if [ -z "${TOKEN}" ]
then
    echo "No token set.  Exiting."
fi

JSON=$(aws sts get-session-token \
    --profile "${PROFILE}" \
    --serial-number "${MFA_SERIAL}" \
    --token-code "${TOKEN}" \
    )

setCredentials
