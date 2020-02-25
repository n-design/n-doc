#/bin/bash

docker run --rm  --volume $(pwd):/data ndesign/n-doc make -j4 delivery

