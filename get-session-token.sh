#!/bin/bash
set -eE

TEMP_PWD=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source "${TEMP_PWD}/setup.sh"

if [[ -f ~/.aws/config ]]; then

    source "${TEMP_PWD}/get-profile.sh"

    echo "$PROFILE"

else

    printf "\nNo ~/.aws/config file found.  Configure aws profiles."

fi

printf "\n${YELLOW}Getting mfa_serial:${NC}"
printf "\n${RED}Check mfa_serial variable exists in [profile %s] block if this fails.${NC}" "${PROFILE}"
MFA_SERIAL=$(aws configure --profile "${PROFILE}" get mfa_serial)

printf "\nAuthenticating with MFA serial: ${GREEN}%s${NC}" "${MFA_SERIAL}"

printf "\n\nEnter token for ${GREEN}%s${NC}: " "${MFA_SERIAL}"
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

setCredentials "12"
