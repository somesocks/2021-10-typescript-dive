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

echo ""
echo "[INFO] starting install for $PACKAGE_NAME";

# load module_hash function
source $PACKAGE_SCRIPTS/module-hash.sh

_check_env () {
	for tool in "$@"
	do
		if ! [ -x "$(command -v $tool)" ]; then
			echo "[ERROR] $tool not found, aborting..." >&2
			exit 1
		fi
	done
}

_check_env pnpm;


_MAKE_MODULE_HASH() {
	echo "[INFO] calculating module hash";
	MODULE_HASH=$(module_hash $PACKAGE_MODULE_MAP)
	echo "[INFO] module hash $MODULE_HASH";
}

_CHECK_MODULE_HASH() {
	echo "[INFO] verifying module hash against install";
	if [ -f $PACKAGE_MODULES/$MODULE_HASH_FILE ]
	then
		DIST_MODULE_HASH=$(cat $PACKAGE_MODULES/$MODULE_HASH_FILE);
		# echo "dist module hash $DIST_MODULE_HASH";
		if [ "$MODULE_HASH" == "$DIST_MODULE_HASH" ]
		then
			echo "[INFO] module hash '$MODULE_HASH' is equal to install module hash '$DIST_MODULE_HASH'";
			SHOULD_REINSTALL=0;
		else
			echo "[INFO] module hash '$MODULE_HASH' is not equal to install module hash '$DIST_MODULE_HASH'";
			SHOULD_REINSTALL=1;
		fi
	else
		SHOULD_REINSTALL=1;
	fi
}


if [ $PACKAGE_USE_MODULE_HASH == 1 ]
then
	# MODULE_HASH_FILE is the name of the source hash to check against
	MODULE_HASH_FILE=.MODULE_HASH

	# SHOULD_REINSTALL is the flag to check if a rebuild is needed
	SHOULD_REINSTALL=1

	_MAKE_MODULE_HASH
	_CHECK_MODULE_HASH
	if [ $SHOULD_REINSTALL == 1 ]
	then
		echo "[INFO] starting install"
		pnpm install --filter $PACKAGE_ROOT
		echo "$MODULE_HASH" > $PACKAGE_MODULES/$MODULE_HASH_FILE
		echo "[INFO] install finished"
	else
		echo "[INFO] modules are up-to-date, exiting"
	fi
else
	echo "[INFO] starting install"
	pnpm install --filter $PACKAGE_ROOT
	echo "[INFO] install finished"
fi

SCRIPT_END=`date +%s`
SCRIPT_RUNTIME=$((SCRIPT_END-SCRIPT_START))
echo "[INFO] package install for $PACKAGE_NAME finished in ${SCRIPT_RUNTIME}s"
echo ""
