#/bin/bash

docker run --rm  --volume $(pwd):/data ndesign/n-doc:3.1.0 make -j4 delivery

