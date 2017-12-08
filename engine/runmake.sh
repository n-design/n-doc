#/bin/bash

docker run --rm  --volume $(pwd):/data krumeich/n-doc make all

