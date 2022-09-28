#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/..
flutter pub get
flutter format --fix --set-exit-if-changed .
flutter analyze --fatal-infos
