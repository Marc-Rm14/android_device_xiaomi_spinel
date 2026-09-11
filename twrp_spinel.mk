$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

PRODUCT_DEVICE := spinel
PRODUCT_NAME := twrp_spinel
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 15
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_RELEASE_NAME := spinel

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
