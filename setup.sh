#!/bin/bash
# shellcheck disable=SC2059
# exit when any command fails
set -eE

# Color
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color

setCredentials () {
    TEMP_ACCESS_KEY_ID=$(echo "${JSON}" | jq -r .Credentials.AccessKeyId)
    TEMP_SECRET_ACCESS_KEY=$(echo "${JSON}" | jq -r .Credentials.SecretAccessKey)
    TEMP_SESSION_TOKEN=$(echo "${JSON}" | jq -r .Credentials.SessionToken)

    TEMP_PROFILE="${PROFILE}_temp"

    printf "\n${RED}Credentials will be stored in ${TEMP_PROFILE}. Proceed? [Y/n]:${NC} "
    read -r INPUT
    if [ -z "${INPUT}" ] || [ "${INPUT}" == "Y" ] || [ "${INPUT}" == "y" ]
    then
        printf "${GREEN}Proceeding...${NC}"
    else
        echo "Exiting."
    fi

    aws configure --profile "${TEMP_PROFILE}" set aws_access_key_id "${TEMP_ACCESS_KEY_ID}"
    aws configure --profile "${TEMP_PROFILE}" set aws_secret_access_key "${TEMP_SECRET_ACCESS_KEY}"
    aws configure --profile "${TEMP_PROFILE}" set aws_session_token "${TEMP_SESSION_TOKEN}"

    printf "\n\n${GREEN}Success.${NC}"
    printf "\nYou can now use credentials for %s for the ${YELLOW}next ${1} hour(s)${NC} with:" "${TEMP_PROFILE}"
    printf "\n--profile %s" "${TEMP_PROFILE}"
    printf "\nEG: ${YELLOW}aws iam list-users --profile %s${NC}\n" "${TEMP_PROFILE}"
}

export -f setCredentials
