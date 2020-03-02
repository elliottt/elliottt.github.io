#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# build resume
make -s -C resume
mkdir -p static/cv
cp resume/resume.pdf static/cv

# build the site
hugo -D --quiet
