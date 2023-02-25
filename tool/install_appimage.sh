#!/usr/bin/env bash

###############################################################################
# Script parameters
###############################################################################

function usage()
{
    cat <<-END
usage: install_appimage.sh [-h]

This script download the latest an AppImage of the Logbook app, places the
binary files in /home/$(whoami)/bin/Logbook** and the icon/desktop files in
/home/$(whoami)/.local/share/**.

optional arguments:
  -h    Show this help message and exit.

dependencies:
  - Linux
  - jq
  - cURL

license: MIT
END
}

while getopts "h t v:" o; do
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

which jq > /dev/null || { echo "ERROR: jq not installed" ; exit 1 ; }

if [[ ! "${OSTYPE}" == "linux-gnu"* ]]; then
  echo "ERROR: This script only work on Linux" >&2
  exit 1
fi

###############################################################################
# Main
###############################################################################

# exit script if there is any error in any command
set -e 

# Get latest version numbers from GitHub API
LOGBOOK_VERSION=$(curl -s https://api.github.com/repos/experimental-software/logbook/releases/latest | jq -r '.tag_name')
APPIMAGE_ASSET=$(curl -s https://api.github.com/repos/experimental-software/logbook/releases/latest  | \
  jq -r '.assets[] | select(.name | endswith(".AppImage")) | .name')
if [[ -z "${APPIMAGE_ASSET}" ]] ; then
  echo "ERROR: Could not find AppImage in release for version '${LOGBOOK_VERSION}'." >&2
  exit 1
fi

# Check if binary files already exist
INSTALL_DIR="/home/$(whoami)/bin/Logbook-${LOGBOOK_VERSION}"
if [[ -d "${INSTALL_DIR}" ]] ; then
  echo "WARNING: Logbook app version '${LOGBOOK_VERSION}' is already installed at '${INSTALL_DIR}'." >&2
  exit 1
fi

echo "Downloading AppImage release for version '${LOGBOOK_VERSION}' into temporary directory '$(pwd)'."
cd $(mktemp -d)
DOWNLOAD_URL="https://github.com/experimental-software/logbook/releases/download/${LOGBOOK_VERSION}/${APPIMAGE_ASSET}"
curl -SL ${DOWNLOAD_URL} -o ${APPIMAGE_ASSET}
chmod +x ${APPIMAGE_ASSET}

echo "Extracting AppImage '${APPIMAGE_ASSET}'"
./${APPIMAGE_ASSET} --appimage-extract > /dev/null

echo "Copy extracted app image into installation directory '${INSTALL_DIR}'."
cp -r squashfs-root ${INSTALL_DIR}

# Normalize binary path in Desktop file
DESKTOP_FILE_SRC="${INSTALL_DIR}/com.experimental-software.logbook.desktop"
sed -i -e "s|Exec=.*|Exec=${INSTALL_DIR}/AppRun|g" ${DESKTOP_FILE_SRC}

# Enable start of Logbook app from launcher
DESKTOP_FILE_TARGET="/home/$(whoami)/.local/share/applications/logbook.desktop"
if [[ -f ${DESKTOP_FILE_TARGET} ]] ; then
  rm ${DESKTOP_FILE_TARGET}
fi
cp ${DESKTOP_FILE_SRC} ${DESKTOP_FILE_TARGET}
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
