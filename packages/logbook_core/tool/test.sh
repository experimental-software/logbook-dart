#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/..
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
