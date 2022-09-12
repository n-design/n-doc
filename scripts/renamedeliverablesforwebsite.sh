#!/usr/bin/env bash

for i in deliverables/*; do 
  d=${i%%_202*}
  s=${i##*.}
  mv $i $d.$s
done

