#/bin/bash

docker run --rm  --volume $(pwd):/data ndesign/n-doc:${engine:-4.2.0} make -j4 delivery

