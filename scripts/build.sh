#!/bin/bash

set -euo pipefail

# build resume
make -s -C resume
mkdir -p static/cv
cp resume/resume.pdf static/cv

# clean out the old site
rm -rf public

# build the site
hugo -D
