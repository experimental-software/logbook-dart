#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Compile binaries
cd $SCRIPT_DIR/..
flutter --version | grep "channel stable" || { echo "Not on stable channel." ; exit 1;  }
flutter pub get
flutter test
flutter build linux
