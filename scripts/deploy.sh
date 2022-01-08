#!/bin/bash

set -euo pipefail

deploy_host="${1:-}"

# clone a copy of the repo for deployment
if [ ! -d "_deploy" ]; then
  echo "_deploy dir missing, cloning the master branch into it"
  remote=$(git config --get remote.origin.url)
  git clone --reference=. --quiet "${remote}" _deploy
else
  echo "Updating the _deploy directory"
  git --git-dir=_deploy/.git pull --quiet
fi

# build the site
echo "Building the site"
./scripts/build.sh

rm -rf _deploy/*
cp -r public/* _deploy/

# commit the update
pushd _deploy > /dev/null

echo "Committing to master"
git add -A
git commit --quiet -e -m "update on $(date "+%F %T")"
git push
popd > /dev/null

# deploy elsewhere
if [ -n "$deploy_host" ]; then
  pushd public > /dev/null
  echo "Deploying to $deploy_host"
  scp -r * "$deploy_host"
  popd > /dev/null
fi
