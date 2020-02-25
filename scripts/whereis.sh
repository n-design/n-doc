#!/bin/bash 

git grep -iHn "$1" | grep -Ev "^common/(test_)?db/config-items.csv"
