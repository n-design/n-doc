#!/bin/bash

function usage() {
    echo 'Usage: $0 [-a | --apply] [-b|--branch <name>] <inputfile>'
    exit ${1:-1}
}

function processCmdLine() {
    while [ -n "$1" ]; do
        case "$1" in
            -b | --branch) branch="$2"; shift; shift;;
            -h | --help) usage 0;;
            -a | --apply) apply="true"; shift;;
            *) inputfile="$1"; shift;;
        esac
    done
    if [ -z "$inputfile" ]; then usage 2; fi
    filenamebranch=${inputfile%%.patch}
    branch="${branch:-$filenamebranch}"
}

processCmdLine $@

git apply --stat $inputfile
git apply --check $inputfile

if [ ! $? -ne 0 -a -n "$apply" ]; then
    git switch -c $branch main
    git am -3 --signoff < $inputfile
fi
