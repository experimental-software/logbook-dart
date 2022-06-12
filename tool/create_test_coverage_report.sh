#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/..

function check_dependencies() {
  which genhtml > /dev/null
  if [[ $? -ne 0 ]] ; then
    echo "ERROR: lcov not installed."
    echo "Run the following command to install lcov:"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      echo "sudo apt install lcov"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      echo "brew install lcov"
    else
      echo "OS type $OSTYPE not supported, yet."
    fi
    exit 1
  fi
}

function open_report() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    firefox coverage/html/index.html > /dev/null 2>&1 &
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/html/index.html
  else
    echo "OS type $OSTYPE not supported, yet."
  fi
}

check_dependencies
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open_report
