#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/..
flutter pub get
flutter format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test
# TODO if format errors, echo warning, fix format and then fail, so that re-run will pass