# WARNING: this package is a controlled file generated from a template
# do not try to make changes in here, they will be overwritten

ROOT=.
SCRIPTS=./package-scripts

MAKEFILE_EXTRA=Makefile.extras.mk

##
##
##	MAKEFILE COMMANDS
##	-----------------
##

default: help

##	make help 	- display the help
##
help:
	@ grep -h "^##.*" ./Makefile $(MAKEFILE_EXTRA)


##
##
##	SETUP
##	-----------------
##

##	make setup 	- setup package
##
setup: install init

##	make install 	- install dependencies for the package
##
install:
	@ $(SCRIPTS)/package-install.sh

##	make init 	- init package from template
##
init: install
	@ $(ROOT)/package-init.sh


##
##
##	BUILD
##	-----------------
##

##	make build 	- build the src and the docs
##
build: setup
	@ $(SCRIPTS)/package-prettier-format.sh
	@ $(SCRIPTS)/package-build.sh

##	make clean 	- remove build artifacts from package
##
clean:
	@ $(SCRIPTS)/package-clean.sh

##	make format	- format the source code (using prettier)
##
format: setup
	@ PACKAGE_USE_AUTOFORMAT=1 $(SCRIPTS)/package-prettier-format.sh


##
##
##	TEST
##	-----------------
##

##	make test-typescript 	- run the typescript test cases
##
test-typescript: setup build
	@ $(SCRIPTS)/package-test-typescript.sh

##	make test-unit-tests 	- run unit tests
##
test-unit-tests: \
	test-mocha-unit-tests \
	test-jest-unit-tests


test-mocha-unit-tests: setup build
	@ MOCHA="$(MOCHA)" $(SCRIPTS)/package-test-mocha-unit-tests.sh

test-jest-unit-tests: setup build
	@ JEST="$(JEST)" $(SCRIPTS)/package-test-jest-unit-tests.sh

##	make test-integration-tests 	- run integration test cases
##
test-integration-tests: \
	test-mocha-integration-tests \
	test-jest-integration-tests

test-mocha-integration-tests: setup build
	@ MOCHA="$(MOCHA)" $(SCRIPTS)/package-test-mocha-integration-tests.sh

test-jest-integration-tests: setup build
	@ JEST="$(JEST)" $(SCRIPTS)/package-test-jest-integration-tests.sh


##	make test-mocha 	- run the mocha test cases (if using mocha)
##
test-mocha: \
	test-mocha-unit-tests \
	test-mocha-integration-tests

##	make test-jest 	- run the jest test cases (if using jest)
##
test-jest: \
	test-jest-unit-tests \
	test-jest-integration-tests


##	make test-eslint 	- run the eslint test cases
##
test-eslint: setup build
	@ $(SCRIPTS)/package-test-eslint.sh

##	make test 	- run all tests
##
test: \
	test-typescript \
	test-eslint \
	test-unit-tests \
	test-integration-tests

##
##
##	PUBLISH
##	-----------------
##

##	make publish-check 	- dry run publish - show what files will be published
##
publish-check: setup build
	@ $(SCRIPTS)/package-check-publish.sh

##	make publish 	- publish the package
##
publish: setup build
	@ $(SCRIPTS)/package-publish.sh

##

include $(MAKEFILE_EXTRA)
