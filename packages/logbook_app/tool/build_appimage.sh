#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOWNLOAD_URL="https://github.com/AppImageCrafters/appimage-builder/releases/download/v1.1.0/appimage-builder-1.1.0-x86_64.AppImage"

cd ${SCRIPT_DIR}/..

if [[ ! -f ./appimage-builder-x86_64.AppImage ]] ; then
  wget -O appimage-builder-x86_64.AppImage ${DOWNLOAD_URL}
  chmod +x appimage-builder-x86_64.AppImage
fi

./appimage-builder-x86_64.AppImage --recipe AppImageBuilder.yml
