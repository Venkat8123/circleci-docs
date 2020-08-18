#!/bin/bash

set -e

# commands to build the widdershins/slate api documentation.
#

build_api_v1() {
    echo "Building API v1 documentation with Slate"
    cd src-api
    bundle exec middleman build --clean --verbose
    echo "Output bundled."
    cp -R build/* /tmp/workspace/api/v1
    echo "Output build moved to /tmp/workspace/api/v1"
    cp -R /tmp/workspace/api/v1/* /tmp/workspace/api
    echo "Also - Move /tmp/workspace/api/v1 so default root (api/) displays api v1."
}

# Fetches the latest api spec
# TODO: merges in custom code samples if needed
# runs redoc-cli to build api documentation.
build_api_v2() {
    echo "Building API v2 documentation with Redoc"
    cd src-api; # rm -r build; rm source/index.html.md
    curl https://circleci.com/api/v2/openapi.json > openapi.json
    redoc-cli bundle openapi.json
    # node node_modules/widdershins/widdershins.js --environment widdershins.apiv2.yml --summary openapi.json -o source/index.html.md
    # bundle exec middleman build --clean --verbose
    cp -R build/* /tmp/workspace/api/v2
    echo "Output build moved to /tmp/workspace/api/v2"
}

# build the Config Reference from slate.
build_crg() {
    echo "Building Configuration Reference with Slate "
    cd src-crg;
    bundle exec middleman build --clean --verbose
    echo "CRG bundle built."
    cp -R build/* /tmp/workspace/crg
    echo "CRG Output build moved to /tmp/workspace/crg"
}


if [ "$1" == "-v1" ]
then
	build_api_v1
elif [ "$1" == "-v2" ]
then
	build_api_v2
elif [ "$1" == "-crg" ]
then
	build_crg
else
	echo "Invalid command"
fi
