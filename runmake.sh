!#/bin/bash

theversion=$(grep 'container: ndesign/n-doc:' .github/workflows/build_n-doc_template.yml | cut -d ':' -f3)

docker run --rm  --volume $(pwd):/data ndesign/n-doc:${engine:-$theversion} make -j${cores:-4} ${@:-delivery}

