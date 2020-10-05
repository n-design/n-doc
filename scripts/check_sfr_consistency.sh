#!/bin/bash

# all sfrs without subsfrs, will remove all x.y where x = 1-9 and y = 1-9
#tail -n +2 common/db/sfr.csv | awk 'BEGIN {FS = OFS = ";"} {print $1}' | grep -v -E '[1-9]\.[1-9]'

DBPATH="common/db/"
SFRFILE="sfr.csv"
FILES="sfr_module.csv sfr_obj.csv sfr_sf.csv sfr_subsfr.csv sfr_tsfi.csv testcase_sfr.csv"
FOUND=0
FOUND2=0
PROBLEMS=""
PROBLEMS2=""

#first find missing sfrs in dpendent documents
for file in $FILES
do
	echo checking $file
	
	for sfr in `tail -n +2 ${DBPATH}$SFRFILE | awk 'BEGIN {FS = OFS = ";"} {print $1}' | grep -v -E '[1-9]\.[1-9]'`
	do
	    if  grep -q $sfr ${DBPATH}$file; then
		true;#echo $sfr found
	    else
		echo $sfr missing
		FOUND=1
	    fi
	done

	if [[ $FOUND -eq 0 ]]; then
		echo $file OK
	else
		echo Please check $file for consistency
		PROBLEMS+=" $file\n"
	fi
	FOUND=0
	echo
done

# Now find entries in dependent documents, not in sfr.csv
echo
echo ---------------------------------------------------
echo "Reverse check:"
for file in $FILES
do
	SFRS=`tail -n +2 ${DBPATH}$file | awk 'BEGIN {FS = OFS = ";"} {print $1}'`
	echo checking $file
	
	if [[ $file == "testcase_sfr.csv" ]]; then
		SFRS=`tail -n +2 ${DBPATH}$file | awk 'BEGIN {FS = OFS = ";"} {print $2}'`
	fi

	for sfr in $SFRS
	do
	    if  grep -q $sfr ${DBPATH}$SFRFILE; then
		true;#echo $sfr found
	    else
		echo $sfr missing
		FOUND2=1
	    fi
	done

	if [[ $FOUND2 -eq 0 ]]; then
		echo $file OK
	else
		echo Please check $file for consistency
		PROBLEMS2+=" $file\n"
	fi
	FOUND2=0
	echo
done

# Now find duplicate entries in dependent sv files
echo
echo ---------------------------------------------------
echo "duplicate check:"
echo $SFRFILE:
sort ${DBPATH}$SFRFILE | uniq -cd
for file in $FILES
do
	echo $file:
	sort ${DBPATH}$file | uniq -cd
done

echo

if [[ -z $PROBLEMS  ]]; then
	echo No Problems found
else
	printf "Please check: \n${PROBLEMS}for consistency (sfrs missing!).\n"
fi

echo

if [[ -z $PROBLEMS2  ]]; then
	echo No Problems found
else
	printf "Please check: \n${PROBLEMS2}for consistency (containing undefined sfrs).\n"
fi
