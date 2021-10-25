
<!--
WARNING: this package is a controlled file generated from a template
do not try to make changes in here, they will be overwritten
-->

# Typescript Package Template

This package is built on top of `@0655-dev/template-package-typescript`, a package template

## Init

In order to create a new package from the template, copy `package-init.sh` from an existing package into an empty folder, and run it.  It will attempt to install `@0655-dev/template-package-typescript` and init a new package from the template.

## Development

The template package is makefile-driven, all relevant package commands are present in the makefile.  Run `make` without any arguments to print out a list of commands.

## Controlled files and default files

`@0655-dev/template-package-typescript` works by taking control of certain files in the package.  Any _controlled_ file in the package will have a warning at the top (like this file), will be overwritten whenever _any_ command is run, so do not try to modify them.

The template also has _default_ files.  These files are created and written with default content when the package is initialized, but never updated, so you can make changes to these files after they are created.  For example, `package.json` is a _default_ file, so when you create a new package `package.json` is only created once, and then can be customized byyou afterwards.

If you want to reset a default file back to its original state, just delete the file and run the init again (or `make setup`).

## Customization

In order to allow you to customize the behavior of the package, some configurations come with a pair of files, a controlled config file, and a default "extras" file:

- eslint is configured by `.eslintrc.js` and `.eslintrc.extras.js`.  `.eslintrc.extras.js` is a default file, so you can make changes in there to add/change eslint rules or plugins.

- several package variables are set by `package-config.sh` and `package-config.extras.sh`.  If you want to set certain environment variables when any package script is run, add/modify variables to `package-config.extras.sh`.

## Support

`@0655-dev/template-package-typescript` is built on top of several shell scripts.  A BASH-compatible shell is necessary for most scripts to work.

The template scripts are tested on OSX and Ubuntu, and use some compatibility shims to make sure the scripts work correctly across both environments.

Some command-line tools are necessary for certain commands, which may not be provided by default with your OS.  If you're missing a tool, the script will print an error saying it needs tool X.
