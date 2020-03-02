#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

publish_host="${1:-}"

# clone a copy of the repo for deployment
if [ ! -d "_deploy" ]; then
    remote=$(git config --get remote.origin.url)
    git clone --reference=. "${remote}" _deploy
else
    (cd _deploy && git pull)
fi

# build the site
. scripts/build.sh

exit 1

# commit the update
pushd _deploy
git add -A
git commit -e -m "update on $(date "+%F %T")"
git push

# deploy elsewhere
if [ -n "$deploy_host" ]; then
  scp -r * "$deploy_host"
fi

popd

