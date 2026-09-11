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
BOARD_MKBOOTIMG_ARGS += --dtb $(DEVICE_PATH)/prebuilt/dtb.img

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64


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

# Boot header version para OrangeFox
BOARD_BOOT_HEADER_VERSION := 4

# AVB (minimal, como transsion mt6789-common)
BOARD_AVB_ENABLE := true

# Kernel image name (GKI ARM64)
BOARD_KERNEL_IMAGE_NAME := Image

# Vendor cmdline (del vendor_boot.img original, sin "bootconfig")
BOARD_VENDOR_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline $(BOARD_VENDOR_CMDLINE)

# ======================
# Kernel y DTB prebuilt
# ======================
TARGET_NO_KERNEL := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

# ======================
# Recovery ramdisk en vendor_boot
# ======================
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
TARGET_NO_RECOVERY := true

# ======================
# Flags críticos para MT6789 + vendor_boot
# ======================
TW_LOAD_VENDOR_BOOT_MODULES := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_HAS_LARGE_FILESYSTEM := true

# Build workarounds para LineageOS 21+
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
ALLOW_MISSING_DEPENDENCIES := true

# Crypto (desencriptar /data)
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_FORCE_KEYMASTER_VER := true

# Herramientas útiles
TW_INCLUDE_FB2PNG := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LPTOOLS := true

# Reducción de tamaño
TW_EXCLUDE_APEX := true
TW_EXCLUDE_LPDUMP := true


# ======================
# Hack de versión (compatible con cualquier ROM)
# ======================
PLATFORM_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# ======================
# Vendor ramdisk fragment (platform) con módulos y HALs
# ======================

# Directorio del recovery con archivos extra (init.recovery.*.rc)
TARGET_RECOVERY_DEVICE_DIRS := $(DEVICE_PATH)

# ======================
# ======================

# ======================
# ======================
