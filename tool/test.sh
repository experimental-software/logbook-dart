#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# logbook_core
cd $SCRIPT_DIR/../packages/logbook_core
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze
dart test

# logbook_cli
cd $SCRIPT_DIR/../packages/logbook_cli
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze
dart test

# logbook_app
$SCRIPT_DIR/../packages/logbook_app/tool/test.sh
