#!/bin/bash

git grep -l "$1" | while read i; do sed -i "s,$1,$2,g" $i; done
