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

# the document to add
the_doc=$1

# copy the skeleton dir and rename the file.
# Also insert the document name 
cp -r scripts/_skeleton "$the_doc"
pushd "$the_doc" >/dev/null
mv skeleton.tex "${the_doc}.tex"
sedi "s/skeleton/${the_doc}/g" .latexmkrc Makefile ${the_doc}.tex
popd >/dev/null

# Add the document to the top level Makefile
sedi "/^LUA_DIR/a ${the_doc^^}_DIR := ${the_doc}" Makefile
sedi "/^PDF_DIRS/ s/$/ \$(${the_doc^^}_DIR)/" Makefile

# Add the document to the releases database table
echo "$the_doc;1.0-SNAPSHOT;\\today;pdf" >>common/db/releases.csv
