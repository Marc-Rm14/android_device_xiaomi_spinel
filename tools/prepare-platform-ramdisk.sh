#!/usr/bin/env bash
set -euo pipefail

DEVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TOP_DIR="$(cd "${DEVICE_DIR}/../../.." && pwd -P)"

PRODUCT_OUT="${TOP_DIR}/out/target/product/spinel"
HOST_OUT="${TOP_DIR}/out/host/linux-x86"

STOCK_RAMDISK="${DEVICE_DIR}/prebuilt/stock_vendor_ramdisk.cpio.lz4"
OUTPUT="${PRODUCT_OUT}/system-compatible-platform.cpio.lz4"

LZ4="${HOST_OUT}/bin/lz4"
MKBOOTFS="${HOST_OUT}/bin/mkbootfs"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

STOCK_CPIO="${WORK_DIR}/platform.cpio"
PLATFORM_ROOT="${WORK_DIR}/platform-root"
PLATFORM_CPIO="${WORK_DIR}/platform-pruned.cpio"

echo "==> Preparing stock PLATFORM ramdisk"

mkdir -p "${PRODUCT_OUT}"
mkdir -p "${PLATFORM_ROOT}"

if [ ! -f "${STOCK_RAMDISK}" ]; then
    echo "ERROR: ${STOCK_RAMDISK} not found"
    exit 1
fi

if [ ! -x "${LZ4}" ]; then
    LZ4="$(command -v lz4 || true)"
fi

if [ -z "${LZ4}" ]; then
    echo "ERROR: lz4 not found"
    exit 1
fi

if [ ! -x "${MKBOOTFS}" ]; then
    echo "ERROR: mkbootfs not found: ${MKBOOTFS}"
    exit 1
fi

echo "==> Decompressing stock PLATFORM"

"${LZ4}" -d -f \
    "${STOCK_RAMDISK}" \
    "${STOCK_CPIO}" \
    >/dev/null

echo "==> Extracting PLATFORM"

(
    cd "${PLATFORM_ROOT}"
    cpio -idm --quiet --no-absolute-filenames < "${STOCK_CPIO}"
)

echo "==> Removing recovery-specific files"

rm -rf "${PLATFORM_ROOT}/res"

rm -f \
    "${PLATFORM_ROOT}/system/etc/init/hw/init.rc" \
    "${PLATFORM_ROOT}/miui.factoryreset.rc" \
    "${PLATFORM_ROOT}/system/bin/adbd" \
    "${PLATFORM_ROOT}/system/bin/fastbootd" \
    "${PLATFORM_ROOT}/system/bin/logcat" \
    "${PLATFORM_ROOT}/system/bin/logd" \
    "${PLATFORM_ROOT}/system/bin/recovery" \
    "${PLATFORM_ROOT}/system/bin/servicemanager" \
    "${PLATFORM_ROOT}/system/bin/sh" \
    "${PLATFORM_ROOT}/system/bin/toolbox" \
    "${PLATFORM_ROOT}/system/bin/toybox" \
    "${PLATFORM_ROOT}/system/bin/update_engine_sideload" \
    "${PLATFORM_ROOT}/system/bin/hw/android.hardware.boot-service.mtk_recovery" \
    "${PLATFORM_ROOT}/system/bin/hw/android.hardware.health-service.example_recovery" \
    "${PLATFORM_ROOT}/system/etc/init/android.hardware.boot-service.mtk_recovery.rc" \
    "${PLATFORM_ROOT}/system/etc/init/android.hardware.health-service.example_recovery.rc" \
    "${PLATFORM_ROOT}/system/etc/init/recovery-persist.rc" \
    "${PLATFORM_ROOT}/system/etc/init/recovery-refresh.rc" \
    "${PLATFORM_ROOT}/system/etc/init/servicemanager.recovery.rc" \
    "${PLATFORM_ROOT}/system/etc/recovery.fstab" \
    "${PLATFORM_ROOT}/system/etc/security/otacerts.zip" \
    "${PLATFORM_ROOT}/system/etc/vintf/manifest/android.hardware.boot-service.mtk.xml" \
    "${PLATFORM_ROOT}/system/etc/vintf/manifest/android.hardware.health-service.example.xml" \
    "${PLATFORM_ROOT}/system/lib64/librecovery_ui.so"

echo "==> Rebuilding PLATFORM"

"${MKBOOTFS}" \
    -d "${PRODUCT_OUT}/system" \
    "${PLATFORM_ROOT}" \
    > "${PLATFORM_CPIO}"

"${LZ4}" \
    -l -12 \
    --favor-decSpeed \
    -f \
    "${PLATFORM_CPIO}" \
    "${OUTPUT}" \
    >/dev/null

echo
echo "PLATFORM ramdisk:"
ls -lh "${OUTPUT}"

echo "Size: $(stat -c '%s' "${OUTPUT}") bytes"
echo "Stock size: 27810115 bytes"
