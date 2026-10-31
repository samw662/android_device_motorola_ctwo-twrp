# SPDX-License-Identifier: Apache-2.0

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# set identity after inheritance to override common defaults
PRODUCT_DEVICE := ctwo
PRODUCT_NAME := twrp_ctwo
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola edge 50 ultra
PRODUCT_MANUFACTURER := motorola
