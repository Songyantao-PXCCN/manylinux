#!/bin/bash

# Stop at any error, show all commands
set -exuo pipefail

# $ git clone git://github.com/docker/buildx && cd buildx
# $ make install
# docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
# docker run -it --rm arm32v7/centos:7
# docker pull arm32v7/debian:9
#
POLICY="manylinux_2_24"
COMMIT_SHA="latest6"
PLATFORM="armv7l"
MULTIARCH_PREFIX="arm32v7/"
BASEIMAGE="${MULTIARCH_PREFIX}debian:9"

#POLICY="manylinux_2_24"
#COMMIT_SHA="latest6"
#PLATFORM="x86_64"
#MULTIARCH_PREFIX="amd64/"
#BASEIMAGE="${MULTIARCH_PREFIX}debian:9"




DEVTOOLSET_ROOTPATH=
PREPEND_PATH=
LD_LIBRARY_PATH_ARG=

# DEVTOOLSET_ROOTPATH="/opt/rh/devtoolset-10/root"
# PREPEND_PATH="${DEVTOOLSET_ROOTPATH}/usr/bin:"
# LD_LIBRARY_PATH_ARG="${DEVTOOLSET_ROOTPATH}/usr/lib64:${DEVTOOLSET_ROOTPATH}/usr/lib:${DEVTOOLSET_ROOTPATH}/usr/lib64/dyninst:${DEVTOOLSET_ROOTPATH}/usr/lib/dyninst:/usr/local/lib64"

export BASEIMAGE
export DEVTOOLSET_ROOTPATH
export PREPEND_PATH
export LD_LIBRARY_PATH_ARG

BUILD_ARGS_COMMON="
	--build-arg POLICY --build-arg PLATFORM --build-arg BASEIMAGE
	--build-arg DEVTOOLSET_ROOTPATH --build-arg PREPEND_PATH --build-arg LD_LIBRARY_PATH_ARG
	--rm -t plcnext/arm/pypa/${POLICY}_${PLATFORM}:${COMMIT_SHA}
	-f docker/Dockerfile docker/
"

docker buildx build \
	--load \
	--cache-from=type=local,src=$(pwd)/.buildx-cache-${POLICY}_${PLATFORM} \
	--cache-to=type=local,dest=$(pwd)/.buildx-cache-staging-${POLICY}_${PLATFORM} \
	${BUILD_ARGS_COMMON}

#docker run --rm -v $(pwd)/tests:/tests:ro plcnext/arm/pypa/${POLICY}_${PLATFORM}:${COMMIT_SHA} /tests/run_tests.sh


if [ -d $(pwd)/.buildx-cache-${POLICY}_${PLATFORM} ]; then
	rm -rf $(pwd)/.buildx-cache-${POLICY}_${PLATFORM}
fi
mv $(pwd)/.buildx-cache-staging-${POLICY}_${PLATFORM} $(pwd)/.buildx-cache-${POLICY}_${PLATFORM}

