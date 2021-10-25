#!/usr/bin/env bash

# WARNING: this package is a controlled file generated from a template
# do not try to make changes in here, they will be overwritten

#
# turn this on to debug script
# set -x

#
# abort on error
# https://sipb.mit.edu/doc/safe-shell/
set -euf -o pipefail

# import other vars from the package config
PACKAGE_ROOT=.
PACKAGE_CONFIG=$PACKAGE_ROOT/package-config.sh
source $PACKAGE_CONFIG

SCRIPT_START=`date +%s`

if [ $PACKAGE_USE_AUTOFORMAT != 1 ]; then exit 0; fi

echo ""
echo "[INFO] running prettier formatting for $PACKAGE_NAME"

pnpx prettier --write $PACKAGE_SRC

SCRIPT_END=`date +%s`
SCRIPT_RUNTIME=$((SCRIPT_END-SCRIPT_START))

echo "[INFO]  prettier formatting for $PACKAGE_NAME finished in ${SCRIPT_RUNTIME}s"
echo ""