#!/bin/bash

cat "$1" | while read line; do
    IFS=';' read -r -a array <<< "$line"
    afo=${array[0]}
    for sfr in ${array[@]}; do
	if [ "$afo" != "$sfr" ]; then
	    echo "$afo;$sfr"
	fi
    done
done
