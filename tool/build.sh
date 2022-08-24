#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ "$OSTYPE" == "darwin"* ]]; then
  $SCRIPT_DIR/build_macos.sh
else
  echo "OS type $OSTYPE not supported, yet."
fi
