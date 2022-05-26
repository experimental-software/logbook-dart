#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function create_backup() {
  if [[ -d ~/bin/engineering_logbook ]]; then
    mv ~/bin/engineering_logbook ~/bin/engineering_logbook.bak
  fi
}

function delete_backup() {
  if [[ -d ~/bin/engineering_logbook.bak ]]; then
    rm -rf ~/bin/engineering_logbook.bak
  fi
}

# Clear existing installation
delete_backup
create_backup

# Compile binaries
cd $SCRIPT_DIR/../..
flutter --version | grep "channel stable" || { echo "Not on stable channel." ; exit 1;  }
flutter build linux
cp -r ./build/linux/x64/release/bundle ~/bin/engineering_logbook

# Create desktop entry
mkdir -p ~/.local/share/ExperimentalSoftware/icons || echo ""
cp $SCRIPT_DIR/test-tube.png ~/.local/share/ExperimentalSoftware/icons/
cp $SCRIPT_DIR/engineering_logbook.desktop ~/.local/share/applications/

# Remove backup files
delete_backup

# Success message
echo
echo "-------------------------------------------------------------"
echo "Created installation"
echo "-------------------------------------------------------------"
echo
cat ~/.local/share/applications/engineering_logbook.desktop
echo
