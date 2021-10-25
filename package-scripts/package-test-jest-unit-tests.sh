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

if [ $PACKAGE_USE_JEST != 1 ]; then exit 0; fi

echo ""
echo "[INFO] running jest tests for $PACKAGE_NAME"

pnpx jest \
	--roots $PACKAGE_DIST \
	--testRegex="((/__tests__/.*|(\\.|/)(spec))\\.[jt]sx?)|((/__tests__/.*|(\\.|/)(spec))/index\\.[jt]sx?)$" \
	$PACKAGE_JEST_ARGS \
	$JEST

SCRIPT_END=`date +%s`
SCRIPT_RUNTIME=$((SCRIPT_END-SCRIPT_START))

echo "[INFO] jest unit tests for $PACKAGE_NAME finished in ${SCRIPT_RUNTIME}s"
echo ""