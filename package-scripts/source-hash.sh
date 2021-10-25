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
PACKAGE_TASKS=$PACKAGE_ROOT/package-scripts

MD5=$PACKAGE_TASKS/md5sum-compat.sh

_check_env () {
	for tool in "$@"
	do
		if ! [ -x "$(command -v $tool)" ]; then
			echo "[ERROR] $tool not found, aborting..." >&2
			exit 1
		fi
	done
}

_check_env xargs cat sed sort;


_source_map () {
	local DIR=$(echo $1 | xargs -0 -n1 dirname)
	local CMD=''
	{
		echo $DIR |
		while read dir
		do 
				# Prefix the contents of each .sourcemap file with the path
				# to the file it came from
				cat "$dir"/.sourcemap | sed \
					-e '/^[ 	]*$/d' \
					-e 's/^[ 	]*//' \
					-e 's/[ 	]*$//' \
					-e '/^#.*$/d' \
					-e 's/\/$/\/\*/' \
					-e 's|^|'"$dir/"'|'
		done
	} | {
		# CMD="find ${DIR} \( -type f -path 3c1190e540f34e4da0282b8497368336 \)"
		CMD="\( -type f -path 3c1190e540f34e4da0282b8497368336 \)"
		while read pattern
		do
			# echo "pattern ${pattern}" 
			CMD="${CMD} -or \( -type f -path '${pattern}' \)"
		done
		CMD="find ${DIR} ${CMD}"
		# echo $CMD
		eval $CMD
	} |
	sort \
		--stable \
		--ignore-case \
		--field-separator=/ \
		--key=2.2 \
		--key=2.1
}

# _source_map $1;


source_hash () {
	_source_map $1 | \
	xargs \
		$MD5  \
	| \
	$MD5
}


# _source_hash $1;
