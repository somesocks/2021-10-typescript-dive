#!/bin/bash

#
# abort on error
# https://sipb.mit.edu/doc/safe-shell/
set -euf -o pipefail

MD5="md5sum"
if [ -x "$(command -v md5sum)" ]; then
  MD5="md5sum"
elif [ -x "$(command -v md5)" ]; then
  MD5="md5 -r"
else 
  echo "[ERROR] no md5-compatible tool found on cli (md5sum/md5). exiting...";
  exit 1;
fi

$MD5 $@
