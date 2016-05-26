#!/bin/sh

set -e

echo 'f4e152313ac6b04ef84f6ef5bd23ddf559616383  bosh-init' > bosh-init.sha1
curl -o bosh-init "https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.91-linux-amd64"
sha1sum -c bosh-init.sha1
chmod +x bosh-init

echo 'd8e36831c3c94bb58be34dd544f44a6c6cb88568  jq' > jq.sha1
curl -o jq -L "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64"
sha1sum -c jq.sha1
chmod +x jq

cp input/bosh-init.json ./
[ ! -e env/$state_file ] || cp env/$state_file bosh-init-state.json

echo "$ssh_key" > id_rsa
chmod 0600 id_rsa

./bosh-init deploy bosh-init.json

cd env-out

git clone "file://$PWD/../env" .

../jq -r '.jobs[0].networks[]|select("vip" == .name).static_ips[0]' \
  < ../bosh-init.json \
  > $( dirname "$state_file" )/director

cp ../bosh-init-state.json "$state_file"

git config user.email "$git_user_email"
git config user.name "$git_user_name"

git add -A .

if git diff-index HEAD | grep -q '.' ; then
  git commit -m "Updated bosh-init-state.json for $( dirname $state_file )"
fi
