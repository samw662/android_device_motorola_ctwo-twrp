// SPDX-License-Identifier: Apache-2.0

#include <android/binder_auto_utils.h>
#include <android/binder_manager.h>
#include <android/hardware/weaver/1.0/IWeaver.h>
#include <hidl/HidlSupport.h>
#include <hidl/HidlTransportSupport.h>

#include <aidl/android/hardware/weaver/IWeaver.h>
#include <aidl/android/hardware/weaver/WeaverReadResponse.h>
#include <aidl/android/hardware/weaver/WeaverReadStatus.h>

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <limits>
#include <memory>
#include <utility>
#include <vector>

namespace {

using AidlIWeaver = ::aidl::android::hardware::weaver::IWeaver;
using AidlConfig = ::aidl::android::hardware::weaver::WeaverConfig;
using AidlReadResponse = ::aidl::android::hardware::weaver::WeaverReadResponse;
using AidlReadStatus = ::aidl::android::hardware::weaver::WeaverReadStatus;
using HidlIWeaver = ::android::hardware::weaver::V1_0::IWeaver;
using HidlConfig = ::android::hardware::weaver::V1_0::WeaverConfig;
using HidlReadResponse = ::android::hardware::weaver::V1_0::WeaverReadResponse;
using HidlReadStatus = ::android::hardware::weaver::V1_0::WeaverReadStatus;
using HidlStatus = ::android::hardware::weaver::V1_0::WeaverStatus;

class WeaverBridge final : public HidlIWeaver {
public:
  WeaverBridge(std::shared_ptr<AidlIWeaver> backend, HidlConfig config)
      : backend_(std::move(backend)), config_(config) {}

  ::android::hardware::Return<void> getConfig(getConfig_cb callback) override {
    callback(HidlStatus::OK, config_);
    return ::android::hardware::Void();
  }

  ::android::hardware::Return<HidlStatus>
  write(uint32_t, const ::android::hardware::hidl_vec<uint8_t> &,
        const ::android::hardware::hidl_vec<uint8_t> &) override {
    return HidlStatus::FAILED;
  }

  ::android::hardware::Return<void>
  read(uint32_t slot, const ::android::hardware::hidl_vec<uint8_t> &key,
       read_cb callback) override {
    if (slot >= config_.slots ||
        slot > static_cast<uint32_t>(std::numeric_limits<int32_t>::max()) ||
        key.size() != config_.keySize) {
      callback(HidlReadStatus::FAILED, HidlReadResponse{});
      return ::android::hardware::Void();
    }

    AidlReadResponse response;
    const auto status =
        backend_->read(static_cast<int32_t>(slot),
                       std::vector<uint8_t>(key.begin(), key.end()), &response);
    if (!status.isOk() || response.timeout < 0 ||
        response.timeout > std::numeric_limits<uint32_t>::max()) {
      callback(HidlReadStatus::FAILED, HidlReadResponse{});
      return ::android::hardware::Void();
    }

    HidlReadStatus hidl_status = HidlReadStatus::FAILED;
    HidlReadResponse hidl_response{};
    switch (response.status) {
    case AidlReadStatus::OK:
      if (response.timeout != 0 || response.value.size() != config_.valueSize) {
        callback(HidlReadStatus::FAILED, HidlReadResponse{});
        return ::android::hardware::Void();
      }
      hidl_status = HidlReadStatus::OK;
      hidl_response.value.resize(response.value.size());
      std::copy(response.value.begin(), response.value.end(),
                hidl_response.value.begin());
      break;
    case AidlReadStatus::INCORRECT_KEY:
      hidl_status = HidlReadStatus::INCORRECT_KEY;
      hidl_response.timeout = static_cast<uint32_t>(response.timeout);
      break;
    case AidlReadStatus::THROTTLE:
      hidl_status = HidlReadStatus::THROTTLE;
      hidl_response.timeout = static_cast<uint32_t>(response.timeout);
      break;
    case AidlReadStatus::FAILED:
      break;
    }

    callback(hidl_status, hidl_response);
    return ::android::hardware::Void();
  }

private:
  std::shared_ptr<AidlIWeaver> backend_;
  HidlConfig config_;
};

} // namespace

int main() {
  constexpr char kAidlService[] = "android.hardware.weaver.IWeaver/default";
  ::ndk::SpAIBinder binder(AServiceManager_checkService(kAidlService));
  if (!binder.get()) {
    std::fprintf(stderr,
                 "ctwo weaver bridge: AIDL Weaver service unavailable\n");
    return 1;
  }

  auto backend = AidlIWeaver::fromBinder(binder);
  if (!backend) {
    std::fprintf(stderr, "ctwo weaver bridge: unable to create AIDL client\n");
    return 1;
  }

  int32_t version = 0;
  if (!backend->getInterfaceVersion(&version).isOk() || version < 2) {
    std::fprintf(stderr, "ctwo weaver bridge: AIDL Weaver v2 required\n");
    return 1;
  }

  AidlConfig aidl_config;
  if (!backend->getConfig(&aidl_config).isOk() || aidl_config.slots <= 0 ||
      aidl_config.keySize <= 0 || aidl_config.valueSize <= 0) {
    std::fprintf(stderr, "ctwo weaver bridge: invalid AIDL Weaver config\n");
    return 1;
  }
  HidlConfig hidl_config{static_cast<uint32_t>(aidl_config.slots),
                         static_cast<uint32_t>(aidl_config.keySize),
                         static_cast<uint32_t>(aidl_config.valueSize)};

  ::android::hardware::configureRpcThreadpool(1, true);
  ::android::sp<WeaverBridge> bridge =
      new WeaverBridge(std::move(backend), hidl_config);
  if (bridge->registerAsService("default") != ::android::OK) {
    std::fprintf(stderr, "ctwo weaver bridge: HIDL registration failed\n");
    return 1;
  }

  ::android::hardware::joinRpcThreadpool();
  return 1;
}
