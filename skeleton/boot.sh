#!/usr/bin/env bash

# Copyright (C) 2022 Toitware ApS. All rights reserved.
# Use of this source code is governed by an MIT-style license that can be
# found in the LICENSE file.

# Directory structure:
#
#   <prefix>/boot.sh <- this file
#   <prefix>/secret.ubjson
#   <prefix>/toit -> <prefix>/ota0 (symbolic link)
#
#   <prefix>/ota0/metadata/current.txt <- (contains "ota0")
#   <prefix>/ota0/metadata/next.txt <- (contains "ota1")
#   <prefix>/ota0/config.ubjson
#   <prefix>/ota0/flash.registry
#   <prefix>/ota0/flash.uuid
#   <prefix>/ota0/flash.validity
#   <prefix>/ota0/toit.boot
#   <prefix>/ota0/toit.boot.image
#
#   <prefix>/ota1/metadata/current.txt <- (contains "ota1")
#   <prefix>/ota1/metadata/next.txt <- (contains "ota0")
#   <prefix>/ota1/config.ubjson
#   <prefix>/ota0/flash.registry
#   <prefix>/ota0/flash.uuid
#   <prefix>/ota0/flash.validity
#   <prefix>/ota0/toit.boot
#   <prefix>/ota0/toit.boot.image

# Compute the directory of this script and use it as the PREFIX.
PREFIX=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Check if we can find the secret.ubjson file.
export TOIT_SECURE_DATA=$(realpath $PREFIX/secret.ubjson)
if [ ! -f "$TOIT_SECURE_DATA" ]; then
  echo "Cannot locate identity file: $TOIT_SECURE_DATA"
  exit 1
fi

# Create the 'toit' symlink to 'ota0' if it doesn't exist yet.
if [ ! -d "$PREFIX/toit" ]; then
  echo ugh
  ln -sTf $PREFIX/ota0 $PREFIX/toit
fi

for (( ; ; )); do
  current=$(cat $PREFIX/toit/metadata/current.txt)
  next=$(cat $PREFIX/toit/metadata/next.txt)
  echo "*******************************"
  echo "*** Running from $current"
  echo "*******************************"

  export TOIT_CONFIG_DATA=$(realpath $PREFIX/toit/config.ubjson)
  export TOIT_FLASH_REGISTRY_FILE=$(realpath $PREFIX/toit/flash.registry)
  export TOIT_FLASH_UUID_FILE=$(realpath $PREFIX/toit/flash.uuid)

  (cd $PREFIX/toit; ./toit.boot toit.boot.image)
  exit_code=$?

  if [ $exit_code -eq 17 ]; then
    echo
    echo
    echo "****************************************"
    echo "*** Testing firmware update in $next"
    echo "****************************************"
    export TOIT_CONFIG_DATA=$(realpath $PREFIX/$next/config.ubjson)
    export TOIT_FLASH_REGISTRY_FILE=$(realpath $PREFIX/$next/flash.registry)
    export TOIT_FLASH_UUID_FILE=$(realpath $PREFIX/$next/flash.uuid)
    rm -f $TOIT_FLASH_UUID_FILE
    (cd $PREFIX/$next && tar --overwrite -xzf ../toit/firmware.tgz && ./toit.boot toit.boot.image)
    firmware_update_exit_code=$?
    echo
    echo
    if [ $firmware_update_exit_code -eq 0 ]; then
      ln -sTf $PREFIX/$next $PREFIX/toit
      echo "****************************************"
      echo "*** Firmware update done: $current -> $next"
      echo "****************************************"
    else
      echo "****************************************"
      echo "*** Firmware update failed (still $current)"
      echo "****************************************"
    fi
    echo
    echo
  elif [ $exit_code -eq 0 ]; then
    echo "****************************************"
    echo "*** Firmware restarting (still $current)"
    echo "****************************************"
  else
    echo "***********************************************"
    echo "*** Firmware crashed with code=$exit_code (still $current)"
    echo "***********************************************"
    # Clear flash.registry and flash.validity files and try again.
    rm -f $TOIT_FLASH_REGISTRY_FILE $PREFIX/toit/flash.validity
    sleep 5
  fi
done
