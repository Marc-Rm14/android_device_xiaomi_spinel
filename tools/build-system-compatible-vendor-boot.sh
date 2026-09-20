#!/usr/bin/env bash
set -euo pipefail

DEVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TOP_DIR="$(cd "${DEVICE_DIR}/../../.." && pwd -P)"

PRODUCT_OUT="${TOP_DIR}/out/target/product/spinel"
HOST_OUT="${TOP_DIR}/out/host/linux-x86"

STOCK_DTB="${DEVICE_DIR}/prebuilt/dtb.img"
STOCK_BOOTCONFIG="${DEVICE_DIR}/prebuilt/bootconfig"

PLATFORM_LZ4="${PRODUCT_OUT}/system-compatible-platform.cpio.lz4"

RECOVERY_LZ4="${PRODUCT_OUT}/obj/PACKAGING/vendor_ramdisk_fragments_intermediates/recovery.cpio.lz4"

MKBOOTIMG="${HOST_OUT}/bin/mkbootimg"
AVBTOOL="${HOST_OUT}/bin/avbtool"
LZ4="${HOST_OUT}/bin/lz4"

OUTPUT_IMAGE="${PRODUCT_OUT}/OrangeFox-R12.0-Unofficial-spinel-system-compatible.img"

VENDOR_BOOT_SIZE=67108864

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

UNSIGNED_IMAGE="${WORK_DIR}/vendor_boot.img"

echo "========================================"
echo " Building system-compatible vendor_boot"
echo "========================================"

if [ ! -f "${STOCK_DTB}" ]; then
    echo "ERROR: Missing ${STOCK_DTB}"
    exit 1
fi

if [ ! -f "${STOCK_BOOTCONFIG}" ]; then
    echo "ERROR: Missing ${STOCK_BOOTCONFIG}"
    exit 1
fi

if [ ! -f "${RECOVERY_LZ4}" ]; then
    echo "ERROR: OrangeFox recovery ramdisk not found:"
    echo "${RECOVERY_LZ4}"
    echo
    echo "Contents of vendor_ramdisk_fragments_intermediates:"
    find "${PRODUCT_OUT}/obj/PACKAGING" \
        -maxdepth 3 \
        -type f \
        -name '*.lz4' \
        2>/dev/null || true
    exit 1
fi

if [ ! -f "${PLATFORM_LZ4}" ]; then
    echo "==> PLATFORM ramdisk not prepared"
    "${DEVICE_DIR}/tools/prepare-platform-ramdisk.sh"
fi

if [ ! -x "${MKBOOTIMG}" ]; then
    echo "ERROR: mkbootimg not found:"
    echo "${MKBOOTIMG}"
    exit 1
fi

if [ ! -x "${AVBTOOL}" ]; then
    echo "ERROR: avbtool not found:"
    echo "${AVBTOOL}"
    exit 1
fi

echo
echo "Stock DTB:"
stat -c '%n: %s bytes' "${STOCK_DTB}"

echo
echo "Stock bootconfig:"
stat -c '%n: %s bytes' "${STOCK_BOOTCONFIG}"

echo
echo "Prepared PLATFORM:"
stat -c '%n: %s bytes' "${PLATFORM_LZ4}"

echo
echo "OrangeFox RECOVERY:"
stat -c '%n: %s bytes' "${RECOVERY_LZ4}"

echo
echo "==> Creating vendor_boot v4"

"${MKBOOTIMG}" \
    --header_version 4 \
    --pagesize 4096 \
    --base 0x00000000 \
    --kernel_offset 0x40000000 \
    --ramdisk_offset 0x66f00000 \
    --tags_offset 0x47c80000 \
    --dtb_offset 0x47c80000 \
    --dtb "${STOCK_DTB}" \
    --vendor_cmdline "bootopt=64S3,32N2,64N2 bootconfig" \
    --vendor_bootconfig "${STOCK_BOOTCONFIG}" \
    --vendor_ramdisk "${PLATFORM_LZ4}" \
    --ramdisk_type RECOVERY \
    --ramdisk_name recovery \
    --vendor_ramdisk_fragment "${RECOVERY_LZ4}" \
    --vendor_boot "${UNSIGNED_IMAGE}"

echo
echo "==> Adding AVB footer"

if [ -f "${PRODUCT_OUT}/build_fingerprint.txt" ]; then
    FINGERPRINT="$(cat "${PRODUCT_OUT}/build_fingerprint.txt")"

    "${AVBTOOL}" add_hash_footer \
        --image "${UNSIGNED_IMAGE}" \
        --partition_size "${VENDOR_BOOT_SIZE}" \
        --partition_name vendor_boot \
        --prop "com.android.build.vendor_boot.fingerprint:${FINGERPRINT}"
else
    "${AVBTOOL}" add_hash_footer \
        --image "${UNSIGNED_IMAGE}" \
        --partition_size "${VENDOR_BOOT_SIZE}" \
        --partition_name vendor_boot
fi

mv -f "${UNSIGNED_IMAGE}" "${OUTPUT_IMAGE}"

cp -f \
    "${OUTPUT_IMAGE}" \
    "${PRODUCT_OUT}/vendor_boot.img"

cp -f \
    "${OUTPUT_IMAGE}" \
    "${PRODUCT_OUT}/OrangeFox-R12.0-Unofficial-spinel.img"

echo
echo "========================================"
echo " vendor_boot generated"
echo "========================================"

stat -c '%n: %s bytes' \
    "${PRODUCT_OUT}/vendor_boot.img"

if [ "$(stat -c '%s' "${PRODUCT_OUT}/vendor_boot.img")" -ne "${VENDOR_BOOT_SIZE}" ]; then
    echo "ERROR: vendor_boot is not exactly 64 MiB"
    exit 1
fi

echo
echo "SHA256:"
sha256sum "${PRODUCT_OUT}/vendor_boot.img"
