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

PACKAGE_ROOT=.
PACKAGE_MANIFEST=$PACKAGE_ROOT/package.json
PACKAGE_SEED="{\\n\\t\"name\": \"\",\\n\\t\"version\": \"1.0.0\",\\n\\t\"private\": true }"
NODE_MODULES=$PACKAGE_ROOT/node_modules

TEMPLATE_PACKAGE_NAME="@0655-dev/typescript-package-template"
TEMPLATE_SRC="$NODE_MODULES/$TEMPLATE_PACKAGE_NAME/src"
TEMPLATE_SRC_DEFAULT="$NODE_MODULES/$TEMPLATE_PACKAGE_NAME/src-default"

IS_NEW_PACKAGE=false

echo ""
echo "[INFO] starting package init"

# check for rsync
if [ ! command -v rsync &> /dev/null ]; then
  echo >&2 "[ERROR] I need rsync but it's not installed. exiting...";
  exit 1;
else
	echo "[INFO] rsync found"
fi

# check for pnpm
if [ ! command -v pnpm &> /dev/null ]; then
  echo >&2 "[ERROR] I need pnpm but it's not installed. exiting...";
  exit 1;
else
	echo "[INFO] pnpm found"
fi



# if package manifest doesn't exist then create one
if [ ! -f "${PACKAGE_MANIFEST}" ]; then
	echo "[INFO] generating manifest"
	echo -e $PACKAGE_SEED > $PACKAGE_MANIFEST
	IS_NEW_PACKAGE=true
	echo "[INFO] done"
else
	echo "[INFO] package manifest found"
fi

# if node_modules isn't set up, we can't init the package
if [ ! -d "${NODE_MODULES}" ]; then
	echo "[INFO] installing packages"
	pnpm install --filter $PACKAGE_ROOT
	echo "[INFO] done"
else
	echo "[INFO] node_modules found"
fi

# if the package ins't isn't set up, we can't init the package
if [ ! -d "${TEMPLATE_SRC}" ]; then
	echo "[INFO] installing template package"
	pnpm install --save-dev "${TEMPLATE_PACKAGE_NAME}@*" --filter $PACKAGE_ROOT
	echo "[INFO] done"
else
	echo "[INFO] template src found"
fi

#
# use rsync to fast-sync the template dir with the package dir
echo "[INFO] copying template to package"
rsync \
	--checksum \
	--recursive \
	--perms \
	--itemize-changes \
	$TEMPLATE_SRC/ \
	$PACKAGE_ROOT
echo "[INFO] done"

#
# use rsync to fast-sync the default template dir with the package dir
echo "[INFO] copying template default files to package"
rsync \
	--recursive \
	--perms \
	--ignore-existing \
	--itemize-changes \
	$TEMPLATE_SRC_DEFAULT/ \
	$PACKAGE_ROOT
echo "[INFO] done"

# if this is a new package, then replace the seed manifest with the template manifest
if [ $IS_NEW_PACKAGE = true ]; then
	echo "[INFO] replacing pacakage.json with template"
	cp $PACKAGE_ROOT/package-template.json $PACKAGE_ROOT/package.json
	echo "[INFO] done"
else
	echo "[INFO] existing package, leaving package.json alone"
fi

echo "[INFO] package init complete"
echo ""
