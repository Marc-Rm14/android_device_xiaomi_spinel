#
# Copyright (C) 2026 The OrangeFox Recovery Project
#

DEVICE_PATH := device/xiaomi/spinel

# ======================
# Architecture
# ======================
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_VARIANT_RUNTIME := cortex-a55
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_VARIANT := cortex-a55
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_BOARD_PLATFORM := mt6789
TARGET_BOOTLOADER_BOARD_NAME := spinel
TARGET_NO_BOOTLOADER := true

# ======================
# Kernel (header v4 para Android 16 GKI)
# ======================
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x40000000
BOARD_RAMDISK_OFFSET := 0x66f00000
BOARD_TAGS_OFFSET := 0x47c80000
BOARD_DTB_OFFSET := 0x47c80000
BOARD_BOOTIMG_HEADER_VERSION := 4
BOARD_VENDOR_BOOT_HEADER_VERSION := 4

BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/xiaomi/spinel
TARGET_KERNEL_CONFIG := gki_defconfig

# ======================
# Assert
# ======================
TARGET_OTA_ASSERT_DEVICE := spinel

# ======================
# Partitions (valores reales de /proc/partitions)
# ======================
BOARD_FLASH_BLOCK_SIZE := 4096

# Super partition
BOARD_SUPER_PARTITION_SIZE := 11811160064
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 11800674304
BOARD_MAIN_PARTITION_LIST := \
    odm_dlkm \
    product \
    system \
    system_dlkm \
    system_ext \
    vendor \
    vendor_dlkm \
    mi_ext

# Metadata
BOARD_METADATAIMAGE_PARTITION_SIZE := 33554432
BOARD_USES_METADATA_PARTITION := true

# Boot partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_VBMETAIMAGE_PARTITION_SIZE := 8388608

# Cache (rescue)
BOARD_CACHEIMAGE_PARTITION_SIZE := 134217728
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

# Userdata
BOARD_USERDATAIMAGE_PARTITION_SIZE := 113925652480

# Virtual A/B
BOARD_USES_VENDOR_BOOTIMAGE := true
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_USES_INIT_BOOTIMAGE := false

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    system \
    system_ext \
    vendor \
    product \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    odm_dlkm \
    system_dlkm \
    vendor_dlkm \
    mi_ext

# ======================
# Filesystem
# ======================
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USES_MKE2FS := true
TARGET_COPY_OUT_VENDOR := vendor

# ======================
# Recovery UI
# ======================
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_TOOLBOX := true
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_NTFS_3G := true
TW_USE_NEW_MINADBD := true
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 1200
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2
TW_HAS_MTP := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_TWRPAPP := true

# ======================
# AVB
# ======================

# ======================
# Platform
# ======================
PLATFORM_SECURITY_PATCH := 2026-03-05
PLATFORM_VERSION := 16

# AVB algorithm for vbmeta_system and vbmeta_vendor

# AVB minimal (como transsion mt6789-common)

# Boot header version para OrangeFox
BOARD_BOOT_HEADER_VERSION := 4

# AVB (minimal, como transsion mt6789-common)
BOARD_AVB_ENABLE := true

# Vendor cmdline (extraída del vendor_boot.img original)
BOARD_VENDOR_CMDLINE := bootopt=64S3,32N2,64N2 bootconfig
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline $(BOARD_VENDOR_CMDLINE)

# Kernel image name (GKI ARM64)
BOARD_KERNEL_IMAGE_NAME := Image
