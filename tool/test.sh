#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$SCRIPT_DIR/../packages/logbook_core/tool/test.sh
$SCRIPT_DIR/../packages/logbook_cli/tool/test.sh
$SCRIPT_DIR/../packages/logbook_app/tool/test.sh
