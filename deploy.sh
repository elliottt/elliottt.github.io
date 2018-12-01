#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# build the site
zola build

# by default, deploy to the master branch
deploy_target=${1:-master}

echo "Deploying to branch ${deploy_target}"

# clone a copy of the repo for deployment
if [ ! -d "_deploy" ]; then
    remote=$(git config --get remote.origin.url)
    git clone --reference=. -b "${deploy_target}" "${remote}" _deploy
else
    (cd _deploy && git pull)
fi

# copy the results to the _deploy directory
rm -rf _deploy/*
cp -r public/* _deploy

# commit the update
pushd _deploy
  git add -A
  git commit -e -m "update on $(date "+%F %T")"
  git push
popd
