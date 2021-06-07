#!/bin/bash

theversion=$(grep 'container: ndesign/n-doc:' .github/workflows/build_n-doc_template.yml | cut -d ':' -f3)

if [[ "$OSTYPE" == "msys" ]]; then
	local_dir=$( pwd | sed -e 's!/!!' | sed -e 's!/!:/!')
	#theversion=latest
else
	local_dir=$(pwd)		
fi

docker run --rm  --volume ${local_dir}:/data ndesign/n-doc:${engine:-$theversion} make -j${cores:-4} ${@:-delivery}



