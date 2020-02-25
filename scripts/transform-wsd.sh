#!/usr/bin/env bash

find "$2" -name "*.wsd" | while read i; do d=$(dirname "$i"); make -C "$d" "$1"; done

