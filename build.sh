#!/bin/bash

set -e

VERSION=1.1.0
REPO_PATH=repo
BUILD_PATH="${REPO_PATH}/_build"

BUILD_PATH_RELEASE="${BUILD_PATH}/release"
BUILD_PATH_DEBUG="${BUILD_PATH}/debug"

get_suffix() {
	local system_version=$(lsb_release -sr | tr -d '.')
	local system_name=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
	local system_machine=$(uname -m | tr '_' '-')
	echo "${system_machine}-${system_name}-${system_version}"
}


SUFFIX_NAME=$(get_suffix)
build() {
	local source_path="${1}"
	local version="${2}"
	local build_type="${3}"
	local debug_suffix=""
	local build_path="${source_path}/${build_type}"
	mkdir -p "${build_path}"
	if ! [ "${build_type}" == "Release" ]; then
		debug_suffix="d"
	fi
	pushd "${build_path}"
		local stripped_version=$(echo -n ${version} | tr '.' '_' )
		git checkout balogger-${stripped_version}
		cmake -DCMAKE_BUILD_TYPE=${build_type} \
			-DLIB_TYPE=SPDLOG \
			-DBRINGAUTO_INSTALL=ON \
			-DBRINGAUTO_SYSTEM_DEP=ON \
			../
		make -j 10
		make install
		pushd INSTALL
			zip -r libbringauto${debug_suffix}-dev_v${version}_${SUFFIX_NAME}.zip ./*
		popd
		mv INSTALL/*.zip ./
	popd
	mv ${build_path}/*.zip ./
}



if ! [ -d "${REPO_PATH}" ]; then
	git clone ssh://git@gitlab.bringauto.com:1999/bring-auto/host-platform/bringauto-logger.git "${REPO_PATH}"
fi

build "${REPO_PATH}" "${VERSION}" Release
build "${REPO_PATH}" "${VERSION}" Debug
