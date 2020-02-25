#!/usr/bin/env bash

# Treat all arguments as directories
texdirs=$@

# If no arguments given, exit.
if [ -z "$texdirs" ]; then
    echo "usage: $0 directory ..."
    exit 1;
fi

# Delete all generated PDFs 
for i in $texdirs; do 
    make -C "$i" clean
    scripts/transform-wsd.sh clean "$i"
done

# Delete all files with suffixes ignored by git
grep "^\*" .gitignore | while read i; do
    find ${texdirs} -name "*$i" -exec rm -f {} \;
done

