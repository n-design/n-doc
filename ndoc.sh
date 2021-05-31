#/bin/bash

docker exec ndoc make -j${cores:-4} ${@:-delivery}

