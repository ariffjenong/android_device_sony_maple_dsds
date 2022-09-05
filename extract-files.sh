#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=maple_dsds
VENDOR=sony

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        vendor/lib/vendor.somc.hardware.camera.provider@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/com.fingerprints.extension@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/com.qualcomm.qti.ant@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.display.color@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.qti.esepowermanager@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.qti.hardware.qdutils_disp@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.qti.hardware.qteeconnector@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.qti.hardware.tui_comm@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.semc.hardware.light@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.semc.hardware.thermal@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.semc.system.idd@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib64/vendor.somc.hardware.security.secd@1.0.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
extract "${MY_DIR}/proprietary-files-vendor.txt" "${SRC}" "${KANG}" --section "${SECTION}"

#
# Blobs fixup start
#

DEVICE_ROOT="${ANDROID_ROOT}"/vendor/"${VENDOR}"/"${DEVICE}"/proprietary

# Fix referenced set_sched_policy for stock audio hal
"${PATCHELF}" --replace-needed "libcutils.so" "libprocessgroup.so" "${DEVICE_ROOT}"/vendor/lib/hw/audio.primary.msm8998.so

# Move drm firmware to vendor
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" "${DEVICE_ROOT}"/vendor/lib/libwvtee.so
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" "${DEVICE_ROOT}"/vendor/lib64/libwvtee.so

# Move fpc firmware to vendor
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" "${DEVICE_ROOT}"/vendor/lib64/lib_fpc_tac_shared.so

# Move hdcp firmware to vendor
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" "${DEVICE_ROOT}"/vendor/lib/libhdcprx_module.so
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" "${DEVICE_ROOT}"/vendor/lib/libhdcptx_module.so
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" "${DEVICE_ROOT}"/vendor/lib64/libhdcprx_module.so
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" "${DEVICE_ROOT}"/vendor/lib64/libhdcptx_module.so

# Move secd firmware to vendor
sed -i "s|/system/etc/firmware|/vendor/etc/firmware|g" "${DEVICE_ROOT}"/vendor/bin/hw/vendor.semc.hardware.secd@1.0-service
sed -i "s|/system/etc/firmware|/vendor/etc/firmware|g" "${DEVICE_ROOT}"/vendor/lib64/libsuntory.so
sed -i "s|/system/etc/firmware|/vendor/etc/firmware|g" "${DEVICE_ROOT}"/vendor/lib64/libtpm.so

#
# Blobs fixup end
#

"${MY_DIR}"/setup-makefiles.sh
