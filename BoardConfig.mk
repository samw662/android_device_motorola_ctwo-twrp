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
TW_EXCLUDE_DEFAULT_USB_INIT := true

DEVICE_RESOLUTION := 1220x2712
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
