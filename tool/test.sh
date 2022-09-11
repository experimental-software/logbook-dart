#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

OUT=$(flutter upgrade --verify-only)
if [[ "$OUT" != *"Flutter is already up to date"* ]]; then
  echo "$OUT"
  exit 1
fi

$SCRIPT_DIR/../packages/logbook_core/tool/test.sh
$SCRIPT_DIR/../packages/logbook_cli/tool/test.sh
$SCRIPT_DIR/../packages/logbook_app/tool/test.sh
