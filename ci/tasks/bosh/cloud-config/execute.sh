#!/bin/bash

set -e


echo '{}' > cloud-config.json.old

for cc in $( find env -name cloud-config.jq ) ; do
  ./env/ci/bin/render $cc | jq --argfile e cloud-config.json.old '$e * .' > cloud-config.json.new
  cp cloud-config.json.{new,old}
done

curl -k -X POST \
  -H 'Content-Type: text/yaml' \
  -d @cloud-config.json.old \
  --user "$username:$password" \
  "https://$( cat env/bosh/director ):25555/cloud_configs/"

# cheating here and blindly uploading referenced stemcells
# these will error after the first time, but we the script does not actually care here
for url in $( for path in $( find . -name stemcell.json ) ; do jq -r '.url' < $path ; done ) ; do
  curl -k -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"location\":\"$url\"}" \
    --user "$username:$password" \
    "https://$( cat env/bosh/director ):25555/stemcells/"
done
