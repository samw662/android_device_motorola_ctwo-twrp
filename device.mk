AB_OTA_UPDATER := true

PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl-qti.ctwo.recovery \
    bootctrl.ctwo.recovery

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc

PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
