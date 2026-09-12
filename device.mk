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
# Librerías críticas del recovery
# ======================
TARGET_RECOVERY_DEVICE_MODULES += \
    libion

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so
