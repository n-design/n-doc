#!/bin/bash

theversion=$(grep 'container: ndesign/n-doc:' .github/workflows/build_n-doc_template.yml | cut -d ':' -f3)

if [[ "$OSTYPE" == "msys" ]]; then
	local_dir=$(pwd | sed -e 's!/!!' | sed -e 's!/!:/!')
else
	local_dir=$(pwd)		
fi

docker run -d -i --name ndoc -v "${local_dir}:/data" ndesign/n-doc:${engine:-$theversion}

