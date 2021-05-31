#/bin/bash

theversion=$(grep 'container: ndesign/n-doc:' .github/workflows/build_n-doc_template.yml | cut -d ':' -f3)

docker run -d -i --name ndoc -v ${PWD}:/data ndesign/n-doc:${engine:-$theversion}

