# SPDX-License-Identifier: Apache-2.0

DEVICE_PATH := device/motorola/ctwo

# ctwo uses a 64-bit arm target
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_BOARD_PLATFORM := pineapple
TARGET_COPY_OUT_VENDOR := vendor

# kernel architecture
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64

# stock image values
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096

# pass the header version to mkbootimg for this branch
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
# stock recovery leaves these fields unset
BOARD_RECOVERY_MKBOOTIMG_ARGS := $(BOARD_MKBOOTIMG_ARGS) --os_version 0 --os_patch_level 0

# stock images use the gki layout
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_NO_KERNEL_OVERRIDE := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 134217728
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    recovery \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    system \
    vendor \
    product \
    system_ext \
    system_dlkm \
    vendor_dlkm
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_MTP := true
TW_SKIP_ADDITIONAL_FSTAB := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# opt in with CTWO_FBE_PROFILE=true
ifeq ($(CTWO_FBE_PROFILE),true)
TW_INCLUDE_CRYPTO := true
TW_USES_VENDOR_LIBS := true
TARGET_USERIMAGES_USE_F2FS := false
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fbe.fstab
endif

# capture Keystore2 startup failures in the isolated validation profile
ifeq ($(CTWO_KEYSTORE_VALIDATION),true)
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
endif

# opt in with CTWO_KEYMINT_VALIDATION=true
ifeq ($(CTWO_KEYMINT_VALIDATION),true)
TW_USES_VENDOR_LIBS := true
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
endif

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/system_ext/private
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/hwservicemanager
ifeq ($(CTWO_KEYMINT_VALIDATION),true)
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/keymint_observer
endif

DEVICE_RESOLUTION := 1220x2712
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

BUILD_BROKEN_PLUGIN_VALIDATION := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults
TW_USE_LEGACY_BATTERY_SERVICES := true
