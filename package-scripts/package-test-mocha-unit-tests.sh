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

PACKAGE_ROOT=.
PACKAGE_SRC=$PACKAGE_ROOT/src
PACKAGE_DIST=$PACKAGE_ROOT/dist
PACKAGE_TASKS=$PACKAGE_ROOT/package-scripts

XARGS=$PACKAGE_TASKS/xargs-compat.sh

SCRIPT_START=`date +%s`

if [ $PACKAGE_USE_MOCHA != 1 ]; then exit 0; fi

echo ""
echo "[INFO] running mocha tests for $PACKAGE_NAME"


( \
	find \
		$PACKAGE_DIST \
		\( -type f -and -name "*mocha.unit.tests.js" \) -or \
		\( -type f -and -path "*/*.mocha.unit.tests/index.js" \) \
	| \
	sort \
		--stable \
		--ignore-case \
		--field-separator=/ \
		--key=2.2 \
		--key=2.1 \
	| \
	$XARGS -r \
		pnpx mocha $PACKAGE_MOCHA_ARGS $MOCHA
)

SCRIPT_END=`date +%s`
SCRIPT_RUNTIME=$((SCRIPT_END-SCRIPT_START))

echo "[INFO] mocha unit tests for $PACKAGE_NAME finished in ${SCRIPT_RUNTIME}s"
echo ""