#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# This file is part of the OrangeFox Recovery Project
#
# OrangeFox is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# OrangeFox is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# See <http://www.gnu.org/licenses/>.
#

#!/bin/bash

# OrangeFox vendorsetup for Redmi Note 15 (spinel)

# Product spec

# ======================
# OrangeFox build variables
# ======================

# A/B device (punto E de la doc)
# export FOX_AB_DEVICE=1

# Virtual A/B device (punto F de la doc)
export FOX_VIRTUAL_AB_DEVICE=1

# Recovery va en vendor_boot
export FOX_VENDOR_BOOT_RECOVERY=1

# export FOX_RECOVERY_VENDOR_BOOT_PARTITION="/dev/block/by-name/vendor_boot"
# export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
# export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

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
export FOX_USE_UPDATED_MAGISKBOOT=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
#export OF_ENABLE_LPTOOLS=1
export FOX_DELETE_AROMAFM=1
export FOX_DELETE_MAGISK_ADDON=1
export FOX_DELETE_INITD_ADDON=1
# export FOX_ADD_API_V36_PREBUILTS=1
export FOX_REFERENCE_VENDOR_BOOT_IMAGE=$(gettop)/device/xiaomi/mydevice/data/stock-vendor_boot.img
