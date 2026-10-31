# SPDX-License-Identifier: Apache-2.0

DEVICE_PATH := device/motorola/ctwo

# ctwo uses a 64-bit arm target
TARGET_ARCH := arm64
TARGET_CPU_ABI := arm64-v8a
TARGET_BOARD_PLATFORM := pineapple

# kernel architecture
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64

# stock image values
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096

# pass the header version to mkbootimg for this branch
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
