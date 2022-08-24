#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/../packages/logbook_app

flutter pub get
flutter test
flutter build macos --no-tree-shake-icons
