#!/usr/bin/env bash

DELIVERY_DIR=${1:-deliverables}
ARCHIVE_FILE=${2:-mauve-vpn-client-documents.tar.gz}

supplements="${DELIVERY_DIR}/mauvecorp_vpn_client_*.db"
all_pdfs=""

for i in ${DELIVERY_DIR}/*.pdf ${supplements}; do
	all_pdfs=$(echo $all_pdfs $(basename $i))
done

tar c -z -v -C ${DELIVERY_DIR} -f ${DELIVERY_DIR}/${ARCHIVE_FILE} ${all_pdfs}
	
