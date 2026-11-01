LOCAL_PATH := $(call my-dir)

define ctwo_stock_module
include $$(CLEAR_VARS)
LOCAL_MODULE := ctwo_$(1)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $$(TARGET_RECOVERY_ROOT_OUT)/vendor_dlkm/lib/modules
LOCAL_MODULE_STEM := $(1).ko
LOCAL_PREBUILT_MODULE_FILE := $$(abspath $$(LOCAL_PATH)/../recovery/root/vendor_dlkm/lib/modules/$(1).ko)
include $$(BUILD_PREBUILT)
endef

$(foreach module,goodix_brl_mmi mmi_info mmi_annotate touchscreen_mmi mmi_relay sensors_class panel_event_notifier,$(eval $(call ctwo_stock_module,$(module))))
