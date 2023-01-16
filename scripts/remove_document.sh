#!/usr/bin/env bash

#set -x

# Cross platform compatibility for use under macOS (BSD)
# (with POSIX compatible sed)
function sedi () {
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@"
}

if [ -z "${1}" ]; then
    echo "Usage: $0 <document>"
    exit 1
fi

# document to be removed
the_doc=$1

# remove directory
rm -rf "$the_doc"

# remove two lines from top level Makefile
sedi "/^${the_doc^^}_DIR/d" Makefile
sedi "s/\s\$(${the_doc^^}_DIR)//" Makefile

# remove version from database
sedi "/$the_doc;/d" common/db/releases.csv
