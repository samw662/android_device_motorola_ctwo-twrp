PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/additional.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/additional.fstab \
    $(DEVICE_PATH)/recovery/root/vendor_dlkm/lib/modules/modules.dep:$(TARGET_COPY_OUT_RECOVERY)/root/vendor_dlkm/lib/modules/modules.dep

PRODUCT_PACKAGES += \
    ctwo_goodix_brl_mmi \
    ctwo_mmi_info \
    ctwo_mmi_annotate \
    ctwo_touchscreen_mmi \
    ctwo_mmi_relay \
    ctwo_sensors_class \
    ctwo_panel_event_notifier

PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
