#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DESKTOP_FILE_SRC=${SCRIPT_DIR}/resources/logbookapp.desktop
DESKTOP_FILE_TARGET="/home/$(whoami)/.local/share/applications/logbookapp.desktop"

ICON_FILE_SRC=${SCRIPT_DIR}/resources/app_icon_256.png
ICON_DIR_TARGET="/home/$(whoami)/.local/share/ExperimentalSoftware/icons"
ICON_FILE_TARGET="${ICON_TARGET_DIR}/app_icon_256.png"

###############################################################################
# Script parameters
###############################################################################

function usage()
{
    cat <<-END
usage: install_linux.sh [-h]

This script download the latest Linux release of the Logbook app, places the
binary files in /home/$(whoami)/bin/Logbook** and the icon and desktop files in
/home/$(whoami)/.local/share/**.

optional arguments:
  -h    Show this help message and exit.

dependencies:
  - Linux
  - jq (https://stedolan.github.io/jq/)
  - cURL

license: MIT
END
}

while getopts "h" o; do
  case "${o}" in
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
LOGBOOK_VERSION=$(curl -s https://api.github.com/repos/experimental-software/logbook/releases/latest | jq -r '.tag_name')
BINARY_ARCHIVE=$(curl -s https://api.github.com/repos/experimental-software/logbook/releases/latest  | \
  jq -r '.assets[] | select(.name | endswith(".tar.gz")) | .name')
if [[ -z "${BINARY_ARCHIVE}" ]] ; then
  echo "ERROR: Could not find binary archive file in release for version '${LOGBOOK_VERSION}'." >&2
  exit 1
fi

# Check if binary files already exist
INSTALL_DIR="/home/$(whoami)/bin/logbookapp-${LOGBOOK_VERSION}"
if [[ -d "${INSTALL_DIR}" ]] ; then
  echo "WARNING: Logbook app version '${LOGBOOK_VERSION}' is already installed at '${INSTALL_DIR}'." >&2
  exit 1
fi

# Download release
cd $(mktemp -d)
echo "Downloading release into temporary directory '$(pwd)'."
DOWNLOAD_URL="https://github.com/experimental-software/logbook/releases/download/${LOGBOOK_VERSION}/${BINARY_ARCHIVE}"
curl -SL ${DOWNLOAD_URL} -o ${BINARY_ARCHIVE}

# Extract binary files into installation directory
mkdir -p ${INSTALL_DIR}
tar xvf ./${BINARY_ARCHIVE} --directory ${INSTALL_DIR}

# Copy icon file into target directory
if [[ -f ${ICON_FILE_TARGET} ]] ; then
  rm ${ICON_FILE_TARGET}
fi
if [[ ! -d ${ICON_TARGET_DIR} ]] ; then
  mkdir -p ${ICON_TARGET_DIR}
fi
cp ${ICON_FILE_SRC} ${ICON_FILE_TARGET} 

# Create desktop file
if [[ -f ${DESKTOP_FILE_TARGET} ]] ; then
  rm ${DESKTOP_FILE_TARGET}
fi
cp ${DESKTOP_FILE_SRC} ${DESKTOP_FILE_TARGET}

# Normalize Exec path in desktop file
sed -i -e "s|Exec=.*|Exec=${INSTALL_DIR}/logbookapp|g" ${DESKTOP_FILE_TARGET}
chmod +x ${DESKTOP_FILE_TARGET}

# Normalize Icon path in desktop file
sed -i -e "s|Icon=.*|Icon=${ICON_FILE_TARGET}|g" ${DESKTOP_FILE_TARGET}

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
