#/bin/bash

docker run --rm  --volume $(pwd):/data ndesign/n-doc:3.0.5 make -j4 delivery

