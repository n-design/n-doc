#/bin/bash

docker run --rm  --volume $(pwd):/data n-design/n-doc:1.0 make -j delivery

