# Inherit from hardware-specific part of the product configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

$(call inherit-product, vendor/twrp/config/common.mk)


PRODUCT_TARGET_VNDK_VERSION := 34
PRODUCT_SHIPPING_API_LEVEL := 34


PRODUCT_DEVICE := spinel
PRODUCT_NAME := twrp_spinel
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 15
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_RELEASE_NAME := spinel
