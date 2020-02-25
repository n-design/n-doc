#!/usr/bin/env bash

# Script for automating releases of CC-documents
# Updates versions of given documents in a fashion
# similar to Apache Maven. 
#
# The script implements a 5-step-process:
#
# 1) Remove "-SNAPSHOT" for each document 
# 2) Commit the changes to common/db/releases.csv
# 3) Tag the HEAD commit for each document
# 4) Increase the version to the next "-SNAPSHOT" for each document
# 5) Commit the changes to common/db/releases.csv and push tags


# set to dry=echo for debugging/development
dry=''

RELEASE_DB=common/db/releases.csv
require_user_confirmation=true

function get_version() {
    ccdoc=$1
    version=$(grep ${ccdoc} "${RELEASE_DB}" | cut -d ';' -f2)
    echo $version
}

function get_next_version() {
    current=$1
    let minorversion=${current##*.}
    majorversion=${current%%.*}
    let minorversion++
    echo ${majorversion}.${minorversion}-SNAPSHOT
}

function set_version() {
    key=$1
    version_to_set=$2
    date_to_set=${3:-$(date "+%d.%m.%Y")}
    sed -i "s/${key};.*/${key};${version_to_set};${date_to_set}/" "$RELEASE_DB"
}

function usage() {
    echo "Usage: $0 [--assume-yes] (--all|<document>...)"
    exit 1
}

function get_all_documents() {
    echo $(tail -n +2 ${RELEASE_DB} | cut -d ';' -f 1 | awk '{printf "%s ", $1}')
}

function processCmdLine() {
    while [ -n "$1" ]; do
        case $1 in 
            --all) alldocs=$(get_all_documents); shift;;
	    --assume-yes) require_user_confirmation=false; shift;;
	    --help) usage && exit 0;;
	    -*) usage && exit 0;;
            *) alldocs+=" $1"; shift;;
        esac
    done
    if [ -z "$alldocs" ]; then
	usage && exit 1;
    fi
}

processCmdLine $@

# Only proceed if no changes in working directory
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Uncommitted changes in repository. Please commit first. Aborting."
    exit 2
fi
if [[ $(git rev-parse --abbrev-ref HEAD) != "master" ]]; then
    echo "Not on branch 'master'. Aborting."
    exit 3
fi


# Check if all documents exist before processing
# Abort if any document is missing.
for doc in $alldocs; do
    grep $doc ${RELEASE_DB} >/dev/null
    if [ $? -ne 0 ]; then
	echo "Document ${doc^^} not found. Aborting."
	usage
    fi
done    


# Sanity check
for doc in $alldocs; do
    documentkey=$doc
    currentversion=$(get_version $documentkey)
    taggedversion=${currentversion%-SNAPSHOT}
    nextversion=$(get_next_version $taggedversion)
    echo "Tagging $doc with ${doc^^}/v$taggedversion (and updating from $currentversion to $nextversion)"
done
if [ "$require_user_confirmation" = "true" ]; then
    read -p "Enter 'yes' to Continue -> " isok
    if [ ${isok^^} != 'YES' ]; then
	echo "Exiting."
	exit 2
    fi
fi    

# Step 1: Remove "-SNAPSHOT" for each document 
# (thus setting the version)
for doc in $alldocs; do
    documentkey=$doc
    currentversion=$(get_version $documentkey)
    taggedversion=${currentversion%-SNAPSHOT}
    #echo "Current: " $currentversion
    #echo "Tag:     " $taggedversion
    set_version $documentkey $taggedversion
done

# Step 2: Commit updated versions
$dry git commit -a -m "Increased versions for release" >/dev/null
to_be_tagged=$(git rev-parse HEAD)

# Step 3: tag the HEAD commit for each document
for doc in $alldocs; do
    taggedversion=$(get_version $doc)
    echo "Tagging $doc with ${doc^^}/v$taggedversion"
    $dry git tag -m "Increased ${doc^^} version to v$taggedversion" "${doc^^}/v$taggedversion" ${to_be_tagged}
done

# Step 4: Increase version to next snapshot
for doc in $alldocs; do
    documentkey=$doc
    currentversion=$(get_version $documentkey)
    nextversion=$(get_next_version $currentversion)
    #echo "Next:    " $nextversion
    set_version $documentkey $nextversion '\\today'
done

# Step 5: Commit new version and push tags
$dry git commit -a -m "Increased versions for next snapshot" >/dev/null
$dry git push
$dry git push --tags
