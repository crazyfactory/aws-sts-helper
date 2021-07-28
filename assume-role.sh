#!/bin/bash
set -eE

TEMP_PWD=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source "${TEMP_PWD}/setup.sh"

printf "\nWhich profile configures source_profile and role_arn: "
read -r PROFILE
if [ -z "${PROFILE}" ]
then
    echo "No profile set.  Exiting."
fi

SOURCE_PROFILE=$(aws configure --profile "${PROFILE}" get source_profile)
ROLE_ARN=$(aws configure --profile "${PROFILE}" get role_arn)

printf "\nAuthenticating with source profile %s." "${SOURCE_PROFILE}"

MFA_SERIAL=$(aws configure --profile "${SOURCE_PROFILE}" get mfa_serial)

printf "\n\nEnter token for %s: " "${MFA_SERIAL}"
read -r TOKEN
if [ -z "${TOKEN}" ]
then
    echo "No token set.  Exiting."
fi

JSON=$(aws sts assume-role \
    --profile "${SOURCE_PROFILE}" \
    --role-arn "${ROLE_ARN}" \
    --role-session-name "access_from_${SOURCE_PROFILE}" \
    --serial-number "${MFA_SERIAL}" \
    --token-code "${TOKEN}"
    )

setCredentials
