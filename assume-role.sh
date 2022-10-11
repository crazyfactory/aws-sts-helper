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

printf "\n${YELLOW}Getting source_profile:${NC}"
printf "\n${RED}Check source_profile variable exists in [profile %s] block if this fails.${NC}" "${PROFILE}"
SOURCE_PROFILE=$(aws configure --profile "${PROFILE}" get source_profile)

printf "\n${YELLOW}Getting mfa_serial:${NC}"
printf "\n${RED}Check mfa_serial variable exists in [profile %s] block if this fails.${NC}" "${PROFILE}"
MFA_SERIAL=$(aws configure --profile "${SOURCE_PROFILE}" get mfa_serial)

printf "\n${YELLOW}Getting role:${NC}"
printf "\n${RED}Check role variable exists in [profile %s] block if this fails.${NC}" "${PROFILE}"
ROLE_ARN=$(aws configure --profile "${PROFILE}" get role_arn)

printf "\n\nAuthenticating with source profile: ${GREEN}%s${NC}" "${SOURCE_PROFILE}"
printf "\nAuthenticating with MFA serial: ${GREEN}%s${NC}" "${MFA_SERIAL}"
printf "\nAssuming role: ${GREEN}%s${NC}" "${ROLE_ARN}"

printf "\n\nEnter token for ${GREEN}%s${NC}: " "${MFA_SERIAL}"
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

setCredentials "12"
