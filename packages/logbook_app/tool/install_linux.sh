#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function create_backup() {
  if [[ -d ~/bin/logbook ]]; then
    mv ~/bin/logbook ~/bin/logbook.bak
  fi
}

function delete_backup() {
  if [[ -d ~/bin/logbook.bak ]]; then
    rm -rf ~/bin/logbook.bak
  fi
}

if [[ ! -d ~/bin ]]; then
  mkdir ~/bin
fi

# Clear existing installation
delete_backup
create_backup

# Compile binaries
cd $SCRIPT_DIR/..
flutter --version | grep "channel stable" || { echo "Not on stable channel." ; exit 1;  }
flutter pub get
flutter test
flutter build linux
cp -r ./build/linux/x64/release/bundle ~/bin/logbook

# Create desktop entry
mkdir -p ~/.local/share/ExperimentalSoftware/icons || echo ""
cp $SCRIPT_DIR/resources/app_icon_256.png ~/.local/share/ExperimentalSoftware/icons/
cp $SCRIPT_DIR/resources/logbook.desktop ~/.local/share/applications/

# Remove backup files
delete_backup

# Success message
echo
echo "-------------------------------------------------------------"
echo "Created installation"
echo "-------------------------------------------------------------"
echo
cat ~/.local/share/applications/logbook.desktop
echo
