#!/bin/bash
# OrangeFox vendorsetup for Redmi Note 15 (spinel)

# Product spec

# ======================
# OrangeFox build variables
# ======================

# A/B device (punto E de la doc)
export FOX_AB_DEVICE=1

# Virtual A/B device (punto F de la doc)
export FOX_VIRTUAL_AB_DEVICE=1

# Recovery va en vendor_boot
export FOX_VENDOR_BOOT_RECOVERY=1

# Keymaster version (punto J de la doc)
export OF_DEFAULT_KEYMASTER_VERSION=4.1

# Device name
export FOX_BUILD_DEVICE=spinel

# Features
export OF_USE_GREEN_LED=0
export OF_FLASHLIGHT_ENABLE=0
export OF_SCREEN_H=2400
export OF_STATUS_H=90
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=1
export OF_ALLOW_DISABLE_NAVBAR=1
export OF_USE_MAGISKBOOT=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
export OF_ENABLE_LPTOOLS=1
export OF_UNMOUNT_SYSTEM=1
export FOX_REFERENCE_VENDOR_BOOT_IMAGE=$(gettop)/device/xiaomi/spinel/prebuilt/stock_vendor_boot.img
export FOX_ADD_API_V36_PREBUILTS=1
