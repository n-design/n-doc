#!/bin/bash

theversion=$(grep 'container: ndesign/n-doc:' .github/workflows/build_n-doc_template.yml | cut -d ':' -f3)
user_id=$(id -u)
group_id=$(id -g)

if [[ "$OSTYPE" == "msys" ]]; then
	local_dir=$(pwd | sed -e 's!/!!' | sed -e 's!/!:/!')
else
	local_dir=$(pwd)		
fi
echo  
docker run --rm  --volume "${local_dir}:/data" --user $user_id:$group_id ndesign/n-doc:${engine:-$theversion} make -j${cores:-4} ${@:-delivery}



