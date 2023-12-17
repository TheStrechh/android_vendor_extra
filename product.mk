#
# Copyright (C) 2022 Giovanni Ricca
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit Android Go Makefile
$(call inherit-product, vendor/extra/config/go.mk)

# Boot animation
TARGET_BOOTANIMATION_HALF_RES := true

# Overlays
PRODUCT_PACKAGES += \
    WebViewOverlay \
    LineageUpdaterOverlay20 \
    RippleSystemUIOverlay

# Rootdir
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/bin/neofetch:$(TARGET_COPY_OUT_SYSTEM)/bin/neofetch

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
