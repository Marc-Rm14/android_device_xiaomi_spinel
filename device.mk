LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),spinel)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif

# ======================
# MTK plpath utils (crítico para recovery MTK)
# ======================
PRODUCT_PACKAGES += \
    mtk_plpath_utils.recovery \
    android.hardware.boot@1.2-mtkimpl \
    android.hardware.boot@1.2-mtkimpl.recovery \
    android.hardware.boot@1.2-service \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service \
    android.hardware.keymaster@4.1 \
    android.hardware.security.keymint \
    android.hardware.security.secureclock \
    android.hardware.security.sharedsecret \
    android.system.keystore2

# ======================
# Librerías críticas del recovery
# ======================
TARGET_RECOVERY_DEVICE_MODULES += \
    libion \
    libpuresoftkeymasterdevice \
    libkeymint \
    libsysutils

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymint.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsysutils.so
