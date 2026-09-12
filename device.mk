LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),spinel)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif

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
