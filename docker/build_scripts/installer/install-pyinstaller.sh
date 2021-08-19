#!/bin/bash
# Top-level build script called from Dockerfile

# Stop at any error, show all commands
set -exuo pipefail

# Get script directory
MY_DIR=$(dirname "${BASH_SOURCE[0]}")


echo ${MY_DIR}

for PREFIX in $(find /opt/_internal/ -mindepth 1 -maxdepth 1 \( -name 'cpython*' -o -name 'pypy*' \)); do

	${PREFIX}/bin/pip install -U --exists-action w ${MY_DIR}/pyinstaller-4.5.1-py3-none-any.whl

done