#!/usr/bin/env bash

DELIVERY_DIR=$1
RELEASE_DB=common/db/releases.csv
SNAPSHOT_DATE=$(git show --no-patch --format=%cd --date=format:"%Y%m%d" $(git rev-parse HEAD))

function get_version() {
    ccdoc=$(echo $(basename ${1}))
    version=$(grep ${ccdoc} "${RELEASE_DB}" | cut -d ';' -f2)
    echo $version
}

# Aufruf mit zwei Argumenten
# $1: Key aus Release-Datenbank
# $2: Name des Dokuments ohne Suffix
function get_target_name() {
    dockey=${1}
    thefilename=${2}
    theversion=$(get_version $dockey)
    if [[ $theversion =~ '-SNAPSHOT' ]]; then
	echo  ${thefilename%.pdf}_${SNAPSHOT_DATE}_v${theversion}
    else
	echo  ${thefilename%.pdf}_v${theversion}
    fi
}

# Benenne alle PDF-Dokumente um
for i in ${DELIVERY_DIR}/*.pdf; do
    mv $i $(get_target_name ${i%.pdf} $i).pdf
done

# Benenne DB-File um
mv ${DELIVERY_DIR}/mauvecorp_vpn_client.db $(get_target_name db ${DELIVERY_DIR}/mauvecorp_vpn_client).db

