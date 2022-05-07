$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Inherit device configuration
$(call inherit-product, device/sony/maple_dsds/device.mk)

# Product API level
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_o.mk)

### BOOTANIMATION
# vendor/nusantara/config/common_full_phone.mk
TARGET_SCREEN_HEIGHT := 1920
TARGET_SCREEN_WIDTH := 1080
# vendor/nusantara/config/common.mk
TARGET_BOOTANIMATION_HALF_RES := true
TARGET_BOOT_ANIMATION_RES := 1080

### Nusantara
$(call inherit-product, vendor/nusantara/config/common_full_phone.mk)
NAD_BUILD_TYPE := OFFICIAL

## Device identifier. This must come after all inclusions
PRODUCT_NAME := nad_maple_dsds
PRODUCT_DEVICE := maple_dsds
PRODUCT_BRAND := Sony
PRODUCT_MODEL := G8142
PRODUCT_MANUFACTURER := Sony

# Google client ID property.
PRODUCT_GMS_CLIENTID_BASE := android-sony

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=maple_dsds \
    PRIVATE_BUILD_DESC="raven-user 13 TP1A.220905.004 8927612 release-keys"

BUILD_FINGERPRINT := google/raven/raven:13/TP1A.220905.004/8927612:user/release-keys
