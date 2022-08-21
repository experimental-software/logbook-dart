#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INSTALLED_APP_PATH=/Applications/logbook.app
BUILT_APP_PATH=./build/macos/Build/Products/Release/logbook.app

function create_backup() {
  if [[ -d $INSTALLED_APP_PATH ]]; then
    mv $INSTALLED_APP_PATH ${INSTALLED_APP_PATH}.bak
  fi
}

function delete_backup() {
  if [[ -d ${INSTALLED_APP_PATH}.bak ]]; then
    rm -rf ${INSTALLED_APP_PATH}.bak
  fi
}

# Compile binaries
cd $SCRIPT_DIR/..
fvm flutter --version | grep "channel stable" || { echo "Not on stable channel." ; exit 1;  }
fvm flutter pub get
fvm flutter test
fvm flutter build macos --no-tree-shake-icons

# Clear existing installation
delete_backup
create_backup

# Install
cp -r $BUILT_APP_PATH $INSTALLED_APP_PATH
rm -rf build/

# Remove backup files
delete_backup

# Success message
echo
echo "-------------------------------------------------------------"
echo "Created installation"
echo "-------------------------------------------------------------"
echo
echo $INSTALLED_APP_PATH
echo
