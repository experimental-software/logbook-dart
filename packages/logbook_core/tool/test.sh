#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/..
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test

# TODO if format errors, echo warning, fix format and then fail, so that re-run will pass