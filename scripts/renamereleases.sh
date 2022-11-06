#!/usr/bin/env bash

DELIVERY_DIR=$1
RELEASE_DB=common/db/releases.csv
SNAPSHOT_DATE=$(git show --no-patch --format=%cd --date=format:"%Y%m%d" $(git rev-parse HEAD))

function get_version() {
    local ccdoc=$(echo $(basename ${1}))
    local version=$(grep "^${ccdoc};" "${RELEASE_DB}" | cut -d ';' -f2)
    echo $version
}

function get_suffix() {
    local ccdoc=$(echo $(basename ${1}))
    local version=$(grep "^${ccdoc};" "${RELEASE_DB}" | cut -d ';' -f4)
    echo $version
}

# Aufruf mit Dateiname
function get_target_name() {
    local filename=$(basename ${1})
    local directory=$(dirname ${1})
    local doc_key=${filename%%.*}
    local thesuffix=$(get_suffix $doc_key)
    local theversion=$(get_version $doc_key)
    if [[ $theversion =~ '-SNAPSHOT' ]]; then
	echo  ${directory}/${doc_key}_${SNAPSHOT_DATE}_v${theversion}.${thesuffix}
    else
        echo  ${directory}/${doc_key}_v${theversion}.${thesuffix}
    fi
}

function is_document() {
    local filename=$(basename ${1})
    local directory=$(dirname ${1})
    local doc_key=${filename%%.*}
    grep $doc_key $RELEASE_DB >/dev/null
}
                         

# Benenne alle PDF-Dokumente um
for i in ${DELIVERY_DIR}/*; do
    if is_document $i; then
        mv $i $(get_target_name $i)
    fi      
done
