#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

###############################################################################
# Script parameters
###############################################################################

function usage()
{
    cat <<-END
usage: install_appimage.sh [-h] [-f appimage_file]

This script extract an AppImage of the Logbook app, places the binary files in
/home/$(whoami)/bin/Logbook** and the icon/desktop files in
/home/$(whoami)/.local/share/**.

If no AppImage file gets provided, it downloads the AppImage from the latest
GitHub release.

optional arguments:
  -f    Local file of the AppImage to be installed.
  -h    Show this help message and exit.

dependencies:
  - Linux
  - jq
  - cURL
  - realpath

license: MIT
END
}

while getopts "h f:" o; do
  case "${o}" in
    f)
      APPIMAGE_FILE=${OPTARG}
      ;;  
    h | *)
      usage
      exit 0
      ;;
  esac
done
shift $((OPTIND-1))

###############################################################################
# Utility functions
###############################################################################

function check_if_binary_files_already_exist() {
  _LOGBOOK_VERSION=$1
  if [[ -z "$_LOGBOOK_VERSION" ]] ; then
    echo "ERROR: Logbook version not provided for previous install check" >&2
    exit 1
  fi
  INSTALL_DIR="/home/$(whoami)/bin/Logbook-${_LOGBOOK_VERSION}"
  if [[ -d "${INSTALL_DIR}" ]] ; then
    echo "WARNING: Logbook app version '${_LOGBOOK_VERSION}' is already installed at '${INSTALL_DIR}'." >&2
    exit 1
  fi
}

###############################################################################
# Verify that dependencies are available
###############################################################################

which jq > /dev/null || { echo "ERROR: jq not installed" ; exit 1 ; }

if [[ ! "${OSTYPE}" == "linux-gnu"* ]]; then
  echo "ERROR: This script only works on Linux" >&2
  exit 1
fi

###############################################################################
# Main
###############################################################################

# exit script if there is any error in any command
set -e

if [[ -f "$APPIMAGE_FILE" ]] ; then
  APPIMAGE_FILE=$(realpath $APPIMAGE_FILE)
fi

cd $(mktemp -d)
echo "Using temporary directory '$(pwd)'."

if [[ -f "$APPIMAGE_FILE" ]] ; then
  cp $APPIMAGE_FILE .
  LOGBOOK_VERSION=$(ls *.AppImage | sed 's/.*\-\(.*\)\-.*/\1/')

  check_if_binary_files_already_exist $LOGBOOK_VERSION
else
  # Get latest version numbers from GitHub API
  LOGBOOK_VERSION=$(curl -s https://api.github.com/repos/experimental-software/logbook/releases/latest | jq -r '.tag_name')
  APPIMAGE_ASSET=$(curl -s https://api.github.com/repos/experimental-software/logbook/releases/latest  | \
    jq -r '.assets[] | select(.name | endswith(".AppImage")) | .name')
  if [[ -z "${APPIMAGE_ASSET}" ]] ; then
    echo "ERROR: Could not find AppImage in release for version '${LOGBOOK_VERSION}'." >&2
    exit 1
  fi

  check_if_binary_files_already_exist $LOGBOOK_VERSION

  echo "Downloading AppImage release for version '${LOGBOOK_VERSION}' into temporary directory '$(pwd)'."
  DOWNLOAD_URL="https://github.com/experimental-software/logbook/releases/download/${LOGBOOK_VERSION}/${APPIMAGE_ASSET}"
  curl -SL ${DOWNLOAD_URL} -o ${APPIMAGE_ASSET}
  chmod +x ${APPIMAGE_ASSET}
fi

if [[ -z "$LOGBOOK_VERSION" ]] ; then
  echo "ERROR: Could not determine Logbook version" >&2
  exit 1
fi
INSTALL_DIR="/home/$(whoami)/bin/Logbook-${LOGBOOK_VERSION}"

echo "Extracting AppImage"
./*.AppImage --appimage-extract > /dev/null

echo "Copy extracted app image into installation directory '${INSTALL_DIR}'."
cp -r squashfs-root ${INSTALL_DIR}

# Create desktop file
DESKTOP_FILE_SRC=${SCRIPT_DIR}/resources/logbook.desktop
DESKTOP_FILE_TARGET="/home/$(whoami)/.local/share/applications/logbook.desktop"
if [[ -f ${DESKTOP_FILE_TARGET} ]] ; then
  rm ${DESKTOP_FILE_TARGET}
fi
cp ${DESKTOP_FILE_SRC} ${DESKTOP_FILE_TARGET}
sed -i -e "s|Exec=.*|Exec=${INSTALL_DIR}/AppRun|g" ${DESKTOP_FILE_TARGET}
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
