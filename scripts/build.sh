#!/bin/bash

set -euo pipefail

# build resume
make -s -C resume
mkdir -p static/cv
cp resume/resume.pdf static/cv

# build the site
hugo -D --quiet
