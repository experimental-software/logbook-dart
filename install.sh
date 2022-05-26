#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  $SCRIPT_DIR/tool/install_linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  $SCRIPT_DIR/tool/install_macos.sh
else
  echo "OS type $OSTYPE not supported, yet."
fi
