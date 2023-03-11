#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

###############################################################################
# Script parameters
###############################################################################

function usage()
{
    cat <<-END
usage: install_linux.sh [-v] [-h]

This script download the latest Linux release of the Logbook app, places the
binary files in /home/$(whoami)/bin/Logbook** and the icon/desktop files in
/home/$(whoami)/.local/share/**.

optional arguments:
  -v    Logbook version, e.g. 0.3.10
  -h    Show this help message and exit.

dependencies:
  - Linux
  - jq (https://stedolan.github.io/jq/)
  - cURL

license: MIT
END
}

while getopts "h v:" o; do
  
  case "${o}" in
    v)
      LOGBOOK_VERSION=${OPTARG}
      ;;
    h | *)
      usage
      exit 0
      ;;
  esac
done
shift $((OPTIND-1))

###############################################################################
# Verify that dependencies are available
###############################################################################

which jq > /dev/null || { echo "ERROR: jq not installed. See https://stedolan.github.io/jq" ; exit 1 ; }

if [[ ! "${OSTYPE}" == "linux-gnu"* ]]; then
  echo "ERROR: This script only works on Linux" >&2
  exit 1
fi

###############################################################################
# Main
###############################################################################

# exit script if there is any error in any command
set -e

# Get release details from GitHub API
if [[ -z "${LOGBOOK_VERSION}" ]] ; then
  LATEST_RELEASE_INFO=$(curl -s https://api.github.com/repos/experimental-software/logbook/releases/latest)
  if [[ $LATEST_RELEASE_INFO == *"API rate limit exceeded"* ]]; then
    echo "ERROR: GitHub API rate limit exceeded. Get the latest version number from" >&2
    echo "https://github.com/experimental-software/logbook/releases/latest and call" >&2
    echo "the script again with the -v flag." >&2
    exit 1
  else
    LOGBOOK_VERSION=$(echo "${LATEST_RELEASE_INFO}" | jq -r '.tag_name')
    BINARY_ARCHIVE=$(echo "${LATEST_RELEASE_INFO}" | \
      jq -r '.assets[] | select(.name | endswith(".tar.gz")) | .name')
    if [[ -z "${BINARY_ARCHIVE}" ]] ; then
      echo "ERROR: Could not find binary archive file in release for version '${LOGBOOK_VERSION}'." >&2
      exit 1
    fi
  fi
else
  BINARY_ARCHIVE="logbookapp-${LOGBOOK_VERSION}-linux-x86_64.tar.gz "
fi

# Check if binary files already exist
INSTALL_DIR="/home/$(whoami)/bin/logbookapp-${LOGBOOK_VERSION}"
if [[ -d "${INSTALL_DIR}" ]] ; then
  echo "WARNING: Logbook app version '${LOGBOOK_VERSION}' is already installed at '${INSTALL_DIR}'." >&2
  exit 0
fi

cd $(mktemp -d)
echo "Downloading release into temporary directory '$(pwd)'."
DOWNLOAD_URL="https://github.com/experimental-software/logbook/releases/download/${LOGBOOK_VERSION}/${BINARY_ARCHIVE}"
curl -SL ${DOWNLOAD_URL} -o ${BINARY_ARCHIVE}

mkdir -p ${INSTALL_DIR}
tar xvf ./${BINARY_ARCHIVE} --directory ${INSTALL_DIR}

# Create desktop file
DESKTOP_FILE_SRC=${SCRIPT_DIR}/resources/logbookapp.desktop
DESKTOP_FILE_TARGET="/home/$(whoami)/.local/share/applications/logbookapp.desktop"
if [[ -f ${DESKTOP_FILE_TARGET} ]] ; then
  rm ${DESKTOP_FILE_TARGET}
fi
cp ${DESKTOP_FILE_SRC} ${DESKTOP_FILE_TARGET}
sed -i -e "s|Exec=.*|Exec=${INSTALL_DIR}/logbookapp|g" ${DESKTOP_FILE_TARGET}
chmod +x ${DESKTOP_FILE_TARGET}

# Success message
echo
echo "-------------------------------------------------------------"
echo "Created installation"
echo "-------------------------------------------------------------"
echo
echo "${INSTALL_DIR}"
echo
cat ${DESKTOP_FILE_TARGET}
echo
