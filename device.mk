LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),spinel)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif

# ======================
# MTK plpath utils (crítico para recovery MTK)
# ======================
PRODUCT_PACKAGES += \
    mtk_plpath_utils.recovery

# ======================
# crypto/FBE
# ======================
PRODUCT_PACKAGES += \
    android.hardware.security.keymint \
    android.hardware.security.secureclock \
    android.hardware.security.sharedsecret

# ======================
# Librerías críticas del recovery
# ======================
TARGET_RECOVERY_DEVICE_MODULES += \
    libion

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so


PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/vendor_ramdisk,$(TARGET_COPY_OUT_VENDOR_RAMDISK))
