#!/bin/bash
# Top-level build script called from Dockerfile

# Stop at any error, show all commands
set -exuo pipefail

# Get script directory
MY_DIR=$(dirname "${BASH_SOURCE[0]}")

echo ${AUDITWHEEL_ARCH}
case ${AUDITWHEEL_ARCH} in
	x86_64) pipx install cmake;;
	armv7l) pipx install ${MY_DIR}/cmake-3.21.1.post1-py2.py3-none-manylinux_2_24_armv7l.whl;;
	*) echo "No Cmake for ${AUDITWHEEL_ARCH}"; exit 0;;
esac