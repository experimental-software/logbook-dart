#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Download dependencies
PUBSPECS=$(find . -name "pubspec.yaml")
for p in $PUBSPECS
do
  PUBSPEC_DIR="${p%pubspec.*}"
  cd $PUBSPEC_DIR
  fvm flutter pub get
  cd -
done

# Compile app
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  $SCRIPT_DIR/../packages/logbook_app/tool/install_linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  $SCRIPT_DIR/../packages/logbook_app/tool/install_macos.sh
else
  echo "OS type $OSTYPE not supported, yet."
fi

# Install CLI
cd $SCRIPT_DIR/../packages/logbook_cli
dart pub get
dart test
dart pub global activate --source path .
