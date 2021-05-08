#/bin/bash

docker run --rm  --volume $(pwd):/data ndesign/n-doc:3.1.1 make -j4 delivery

