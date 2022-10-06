#!/bin/bash

# Skript for creating a persisted database file
# from the CSV files.
#
# Creates a DB-file suitable for viewing with SQLite
# Browser
#
# Do not commit the resulting DB-file to the repository.
# This file should always be created fresh from current data


# Change the file name to reflect your organization/product
DB_FILE=${1:-mauvecorp_vpn_client.db}

TMP_PREFIX="_tmp"

rm -f "$DB_FILE"
for i in *.csv; do
  # Remove header line with field names
  tail -n +2 "$i" > "${TMP_PREFIX}_${i}"
done
sqlite3 << EOF
.open $DB_FILE
.read ./create_tables.sql
.mode csv
.separator ";"
.import ${TMP_PREFIX}_bundle_module.csv bundle_module
.import ${TMP_PREFIX}_bundles.csv bundles
.import ${TMP_PREFIX}_bundle_status.csv bundle_status
.import ${TMP_PREFIX}_interfaces.csv interfaces
.import ${TMP_PREFIX}_modules.csv modules
.import ${TMP_PREFIX}_sfr.csv sfr
.import ${TMP_PREFIX}_sfr_subsfr.csv sfr_subsfr
.import ${TMP_PREFIX}_sfr_module.csv sfr_module
.import ${TMP_PREFIX}_subsystems.csv subsystems
.import ${TMP_PREFIX}_sf.csv sf
.import ${TMP_PREFIX}_tsfi.csv tsfi
.import ${TMP_PREFIX}_sfr_sf.csv sfr_sf
.import ${TMP_PREFIX}_sfr_tsfi.csv sfr_tsfi
.import ${TMP_PREFIX}_obj.csv obj
.import ${TMP_PREFIX}_sfr_obj.csv sfr_obj
.import ${TMP_PREFIX}_spd.csv spd
.import ${TMP_PREFIX}_spd_obj.csv spd_obj
.import ${TMP_PREFIX}_errors.csv errors
.import ${TMP_PREFIX}_testcases.csv testcases
.import ${TMP_PREFIX}_testcase_module.csv testcase_module
.import ${TMP_PREFIX}_testcase_sfr.csv testcase_sfr
.import ${TMP_PREFIX}_testcase_tsfi.csv testcase_tsfi
EOF
# Cleanup
rm ${TMP_PREFIX}_*.csv
