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
echo "[INFO] starting package build for $PACKAGE_NAME";

_check_env () {
	for tool in "$@"
	do
		if ! [ -x "$(command -v $tool)" ]; then
			echo "[ERROR] $tool not found, aborting..." >&2
			exit 1
		fi
	done
}

_check_env pnpx rsync mktemp;

# load source_hash function
source $PACKAGE_SCRIPTS/source-hash.sh

echo "[INFO] starting build check"

_MAKE_SOURCE_HASH() {
	echo "[INFO] calculating source hash";
	SOURCE_HASH=$(source_hash $PACKAGE_SOURCE_MAP)
	echo "[INFO] source hash $SOURCE_HASH";
}

_CHECK_SOURCE_HASH() {
	echo "[INFO] verifying source hash against build";
	if [ -f $PACKAGE_DIST/$SOURCE_HASH_FILE ]
	then
		DIST_SOURCE_HASH=$(cat $PACKAGE_DIST/$SOURCE_HASH_FILE);
		# echo "dist source hash $DIST_SOURCE_HASH";
		if [ "$SOURCE_HASH" == "$DIST_SOURCE_HASH" ]
		then
			echo "[INFO] source hash '$SOURCE_HASH' is equal to dist source hash '$DIST_SOURCE_HASH'";
			SHOULD_REBUILD=0;
		else
			echo "[INFO] source hash '$SOURCE_HASH' is not equal to dist source hash '$DIST_SOURCE_HASH'";
			SHOULD_REBUILD=1;
		fi
	else
		SHOULD_REBUILD=1;
	fi
}

_MAKE_BUILD_DIR () {
	#
	# make a temporary build dir
	# this command is linux / osx agnostic
	# https://unix.stackexchange.com/questions/30091/fix-or-alternative-for-mktemp-in-os-x
	echo "[INFO] creating temporary build dir"
	BUILD_DIR=''
	BUILD_DIR=`mktemp -d 2>/dev/null || mktemp -d -t 'build-dir'`
}

_UNMAKE_BUILD_DIR () {
	#
	# clean up build dir
	echo "[INFO] removing temporary build dir"
	rm -rf $BUILD_DIR
}

_BUILD_TS () {
	#
	# build typescript into temp dir
	echo "[INFO] compiling TS into build dir"
	(pnpx tsc \
		--outDir "$BUILD_DIR"
		--noEmitOnError false \
	) > /dev/null 2>&1 || true
}

_COPY_ASSETS () {
	#
	# copy src/**/*.js into temp dir
	echo "[INFO] copying non-TS assets into build dir"
	rsync \
		--update \
		--recursive \
		--exclude='*.ts' \
		--exclude='*.tsx' \
		--include='*' \
		$PACKAGE_SRC/ \
		$BUILD_DIR
		# --itemize-changes \
}

_BUILD_SOURCE_HASH_FILE () {
	echo "$SOURCE_HASH" > $BUILD_DIR/$SOURCE_HASH_FILE
}

_WRITE_BUILD_TO_DIST () {
	#
	# use rsync to fast-sync the dist dir with the build dir
	# 'temp' is excluded to work around an issue with local temp dirs getting used
	echo "[INFO] writing build to dist"
	rsync \
		--update \
		--recursive \
		--exclude='temp' \
		--delete \
		$BUILD_DIR/ \
		$PACKAGE_DIST
		# --itemize-changes \
}

_CLEANUP () {
	_UNMAKE_BUILD_DIR || true
	echo ""
}


if [ $PACKAGE_USE_SOURCE_HASH == 1 ]
then
	SOURCE_HASH_FILE=.SOURCE_HASH 	# SOURCE_HASH_FILE is the name of the source hash to check against
	SHOULD_REBUILD=1 	# SHOULD_REBUILD is the flag to check if a rebuild is needed
	_MAKE_SOURCE_HASH
	_CHECK_SOURCE_HASH
	if [ $SHOULD_REBUILD == 1 ]
	then
		echo "[INFO] starting build"
		trap _CLEANUP ERR EXIT
		_MAKE_BUILD_DIR
		_COPY_ASSETS
		_BUILD_TS
		_BUILD_SOURCE_HASH_FILE
		_WRITE_BUILD_TO_DIST
		echo "[INFO] build finished"
	else
		echo "[INFO] build is up-to-date, exiting"
	fi
else
	echo "[INFO] starting build"
	trap _CLEANUP ERR EXIT
	_MAKE_BUILD_DIR
	_COPY_ASSETS
	_BUILD_TS
	_WRITE_BUILD_TO_DIST
	echo "[INFO] build finished"
fi


SCRIPT_END=`date +%s`
SCRIPT_RUNTIME=$((SCRIPT_END-SCRIPT_START))
echo "[INFO] package build for $PACKAGE_NAME finished in ${SCRIPT_RUNTIME}s"
echo ""
