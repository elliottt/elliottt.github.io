#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# build resume
(cd resume && make)
mkdir -p static/cv
cp resume/resume.pdf static/cv

# build the site
zola build
