#!/bin/bash
#
# Copyright (C) 2022 Giovanni Ricca
#
# SPDX-License-Identifier: Apache-2.0
#

# Override host metadata to make builds more reproducible and avoid leaking info
export BUILD_USERNAME=TheStrechh
export BUILD_HOSTNAME=android-build

# Disable ART debugging
export USE_DEX2OAT_DEBUG=false
export WITH_DEXPREOPT_DEBUG_INFO=false

# Hardcode High Memory Parallel Process
export NINJA_HIGHMEM_NUM_JOBS=1

# goofy ahh build env
if [[ $(cat /proc/sys/kernel/hostname) == "SpeedHorn.LegacyServer.in" ]]; then
    unset JAVAC
fi

# Defs
LOS_VERSION=$(grep "PRODUCT_VERSION_MAJOR" $(gettop)/vendor/lineage/config/version.mk | sed 's/PRODUCT_VERSION_MAJOR = //g' | head -1)
VENDOR_EXTRA_PATH=$(gettop)/vendor/extra
VENDOR_PATCHES_PATH="${VENDOR_EXTRA_PATH}"/build/patches
VENDOR_PATCHES_PATH_VERSION="${VENDOR_PATCHES_PATH}"/lineage-"${LOS_VERSION}"

# Logging defs
LOGI() {
    echo -e "\n\033[32m[INFO]: $1\033[0m\n"
}

LOGW() {
    echo -e "\n\033[33m[WARNING]: $1\033[0m\n"
}

LOGE() {
    echo -e "\n\033[31m[ERROR]: $1\033[0m\n"
}

# Apply patches
if [[ "${APPLY_PATCHES}" == "true" ]]; then
    LOGI "Applying Patches"

    for project_name in $(cd "${VENDOR_PATCHES_PATH_VERSION}"; echo */); do
        project_path="$(tr _ / <<<$project_name)"

        cd $(gettop)/${project_path}
        git am "${VENDOR_PATCHES_PATH_VERSION}"/${project_name}/*.patch --no-gpg-sign
        git am --abort &> /dev/null
    done

    # Return to source rootdir
    cd /home/carlos/lineage
fi
