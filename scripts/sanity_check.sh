#!/bin/sh

# Inkonsistenzen in der Datenbank: Suche alle Vorkommen von "is undefined"
find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color -e "is undefined" -e "To Do"' \;

