PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.security.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.security.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/additional.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/additional.fstab \
    $(DEVICE_PATH)/recovery/root/system/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/manifest.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/ctwo-weaver.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/ctwo-weaver.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/ctwo-security.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/ctwo-security.xml \
    $(DEVICE_PATH)/recovery/root/vendor_dlkm/lib/modules/modules.dep:$(TARGET_COPY_OUT_RECOVERY)/root/vendor_dlkm/lib/modules/modules.dep \
    $(DEVICE_PATH)/recovery/root/vendor/firmware_mnt/mountpoint:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/firmware_mnt/mountpoint

PRODUCT_PACKAGES += \
    ctwo_weaver_hidl_bridge \
    ctwo_goodix_brl_mmi \
    ctwo_mmi_info \
    ctwo_mmi_annotate \
    ctwo_touchscreen_mmi \
    ctwo_mmi_relay \
    ctwo_sensors_class \
    ctwo_panel_event_notifier \
    ctwo_snd_event_dlkm \
    ctwo_q6_pdr_dlkm \
    ctwo_q6_notifier_dlkm \
    ctwo_gpr_dlkm \
    ctwo_spf_core_dlkm \
    ctwo_adsp_loader_dlkm

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/etc/init/zz_ctwo-servicemanager.rc:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/init/zz_ctwo-servicemanager.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/init/ctwo-hwservicemanager-mount.rc:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/init/ctwo-hwservicemanager-mount.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/init/zz_ctwo-hwservicemanager.rc:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/init/zz_ctwo-hwservicemanager.rc \
    $(DEVICE_PATH)/recovery/root/system/bin/ctwo-hwsm/mountpoint:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/ctwo-hwsm/mountpoint

TARGET_RECOVERY_DEVICE_MODULES += ctwo_hwservicemanager_image

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/ctwo-adsp/mountpoint:$(TARGET_COPY_OUT_RECOVERY)/root/ctwo-adsp/mountpoint

TARGET_RECOVERY_DEVICE_MODULES += ctwo_adsp_image

# enable only for VINTF and Keystore2 startup checks
ifeq ($(CTWO_KEYSTORE_VALIDATION),true)
ifeq ($(CTWO_FBE_PROFILE),true)
$(error CTWO_KEYSTORE_VALIDATION cannot be combined with CTWO_FBE_PROFILE)
endif
ifneq ($(TW_INCLUDE_CRYPTO),)
$(error CTWO_KEYSTORE_VALIDATION requires TW_INCLUDE_CRYPTO to be unset)
endif

PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/task_profiles.json \
    $(DEVICE_PATH)/recovery/root/init.recovery.task-profiles.rc:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/init/init.recovery.task-profiles.rc

TARGET_RECOVERY_DEVICE_MODULES += \
    keystore2 \
    android.system.keystore2-service.xml \
    keystore2.rc

TW_RECOVERY_ADDITIONAL_RELINK_BINARY_FILES += \
    $(TARGET_OUT_EXECUTABLES)/keystore2

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.confirmationui-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.confirmationui@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@3.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.1.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.keymint-V3-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.rkp-V3-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.secureclock-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.sharedsecret-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.security.aaid_aidl-cpp.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.security.compat-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.system.keystore2-V4-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/lib_android_keymaster_keymint_utils.so \
    $(TARGET_RECOVERY_ROOT_OUT)/system/lib64/libandroidicu.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libcppbor_external.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libcppcose_rkp.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4_1support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_messages.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_portable.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymint.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymint_support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore-attestation-application-id.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore2_aaid.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore2_apc_compat.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore2_crypto.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkm_compat.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkm_compat_service.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpackagelistparser.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpcre2.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsoft_attestation_cert.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsqlite.so
endif

# opt in with CTWO_KEYMINT_VALIDATION=true
ifeq ($(CTWO_KEYMINT_VALIDATION),true)
ifeq ($(CTWO_KEYSTORE_VALIDATION),true)
$(error CTWO_KEYMINT_VALIDATION cannot be combined with CTWO_KEYSTORE_VALIDATION)
endif
ifeq ($(CTWO_FBE_PROFILE),true)
$(error CTWO_KEYMINT_VALIDATION cannot be combined with CTWO_FBE_PROFILE)
endif
ifneq ($(TW_INCLUDE_CRYPTO),)
$(error CTWO_KEYMINT_VALIDATION requires TW_INCLUDE_CRYPTO to be unset)
endif

# Precreate the mountpoint in the ramdisk; init must not mkdir under system_file.
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/task_profiles.json \
    $(DEVICE_PATH)/recovery/root/init.recovery.task-profiles.rc:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/init/init.recovery.task-profiles.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/init/ctwo-keystore2.rc:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/init/ctwo-keystore2.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/init/ctwo-binder-observer.rc:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/init/ctwo-binder-observer.rc \
    $(DEVICE_PATH)/recovery/root/system/bin/ctwo-tools/.mountpoint:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/ctwo-tools/.mountpoint

TARGET_RECOVERY_DEVICE_MODULES += \
    keystore2 \
    android.system.keystore2-service.xml \
    ctwo_binder_observer_image

TW_RECOVERY_ADDITIONAL_RELINK_BINARY_FILES += \
    $(TARGET_OUT_EXECUTABLES)/keystore2

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.confirmationui-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.confirmationui@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@3.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.1.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.keymint-V3-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.rkp-V3-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.secureclock-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.sharedsecret-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.security.aaid_aidl-cpp.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.security.compat-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.system.keystore2-V4-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/lib_android_keymaster_keymint_utils.so \
    $(TARGET_RECOVERY_ROOT_OUT)/system/lib64/libandroidicu.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libcppbor_external.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libcppcose_rkp.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4_1support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_messages.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_portable.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymint.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymint_support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore-attestation-application-id.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore2_aaid.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore2_apc_compat.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore2_crypto.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkm_compat.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkm_compat_service.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpackagelistparser.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpcre2.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsoft_attestation_cert.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsqlite.so
endif

TW_RECOVERY_ADDITIONAL_RELINK_BINARY_FILES += \
    $(TARGET_OUT_EXECUTABLES)/ctwo_weaver_hidl_bridge

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.weaver-V2-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.weaver@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsysutils.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libresetprop.so

PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
