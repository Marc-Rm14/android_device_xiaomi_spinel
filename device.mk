LOCAL_PATH := $(call my-dir)

# Dynamic
PRODUCT_USE_DYNAMIC_PARTITIONS := true

ENABLE_VIRTUAL_AB := true

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Paquetes críticos de MTK para recovery
PRODUCT_PACKAGES += \
    mtk_plpath_utils.recovery \
    android.hardware.boot@1.2-mtkimpl \
    android.hardware.boot@1.2-mtkimpl.recovery

# Librerías que suelen necesitar relink en MTK
TARGET_RECOVERY_DEVICE_MODULES += \
    libion \
    libsysutils

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsysutils.so
