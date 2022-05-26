#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INSTALLED_APP_PATH=/Applications/engineering_logbook.app
BUILT_APP_PATH=./build/macos/Build/Products/Release/engineering_logbook.app

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

# Clear existing installation
delete_backup
create_backup

# Compile binaries
cd $SCRIPT_DIR/..
flutter --version | grep "channel stable" || { echo "Not on stable channel." ; exit 1;  }
flutter build macos --no-tree-shake-icons
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
