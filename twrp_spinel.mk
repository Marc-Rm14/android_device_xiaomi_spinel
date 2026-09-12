$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

PRODUCT_USE_DYNAMIC_PARTITIONS := true
ENABLE_VIRTUAL_AB := true
PRODUCT_TARGET_VNDK_VERSION := 36
PRODUCT_SHIPPING_API_LEVEL := 36


PRODUCT_DEVICE := spinel
PRODUCT_NAME := twrp_spinel
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 15
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_RELEASE_NAME := spinel

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
