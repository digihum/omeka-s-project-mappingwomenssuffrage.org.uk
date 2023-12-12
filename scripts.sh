#!/bin/bash

# Color output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW="\033[0;33m"
WHITE='\033[0;37m'
RESET='\033[0m'

VERSION=$2

################################################################################
# CHECK REQUIREMENTS                                                           #
################################################################################
CheckRequirements()
{
    echo -e "${YELLOW}Checking for wget and unzip ${RESET}"

    # check we have composer and unzip
    if command -v wget &> /dev/null
        then
            echo -e "${GREEN}Found wget.${RESET}"
        else
            echo -e "${RED}Could not find wget :(${RESET}"
            exit 1
    fi

    if command -v unzip &> /dev/null
        then
            echo -e "${GREEN}Found unzip.${RESET}"
        else
            echo -e "${RED}Could not find unzip :(${RESET}"
    fi

}

################################################################################


Help()
{
   # Display Help
   echo "Fetches scripts"
   echo
   echo "Syntax: scripts.sh [-h|v] VERSION"
   echo "options:"
   echo "h     Print this Help."
   echo "v     Fetches scripts with a specific version"
   echo
}

while getopts 'hb' flag; do
  case "${flag}" in
    h) Help ;;
    v) GetVersion ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

# Check if we have the requirements

CheckRequirements

url="https://github.com/digihum/omeka-project-scripts/archive/refs/tags/v0.1.zip"
    message="Downloaded latest scripts version"
getVersion(){
    url="https://github.com/digihum/omeka-project-scripts/archive/refs/tags/v${VERSION}.zip"
    message="Downloaded specific scripts version v${VERSION}"
}

rm -r scripts
wget $url -O scripts.zip
unzip -d scripts/ -j scripts.zip
rm scripts.zip

echo -e "${GREEN}${message}${RESET}"