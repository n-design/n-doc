#!/bin/bash

function usage() {
    echo 'Usage: $0 [-f|--file <outputfile>]'
    exit 2
}

function processCmdLine() {
    while [ -n "$1" ]; do
        case "$1" in
            -f | --file) outputfile="$2"; shift; shift;;
            *) usage && exit 1;;
        esac
    done
    branch=$(git branch --show-current)
    outputfile="${outputfile:-${current//\//_}.patch}"
}

processCmdLine $@

spinoff=$(git merge-base $branch main)
git format-patch $spinoff --stdout >"${outputfile}"
