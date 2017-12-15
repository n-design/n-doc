#!/bin/bash

latesttag=$(git describe --tags --abbrev=0)

docker build --rm --tag n-design/n-doc:${latesttag} .
