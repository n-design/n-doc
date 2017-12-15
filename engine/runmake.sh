#/bin/bash

docker run --rm  --volume $(pwd):/data n-design/n-doc make -j delivery

