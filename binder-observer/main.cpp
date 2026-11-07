#include <android/binder_ibinder.h>
#include <android/binder_manager.h>
#include <android/log.h>

#include <cstring>

namespace {

constexpr char kTag[] = "ctwo-binder-observer";
constexpr const char* kServices[] = {
        "android.hardware.security.keymint.IKeyMintDevice/default",
        "android.hardware.security.sharedsecret.ISharedSecret/default",
        "android.hardware.security.secureclock.ISecureClock/default",
        "vendor.qti.hardware.qseecom.IQSEECom/default",
};

bool IsApprovedService(const char* name) {
    for (const char* service : kServices) {
        if (std::strcmp(name, service) == 0) return true;
    }
    return false;
}

}  // namespace

int main(int argc, char** argv) {
    if (argc != 2 || !IsApprovedService(argv[1])) {
        __android_log_print(ANDROID_LOG_ERROR, kTag, "invalid service argument");
        return 64;
    }

    const char* name = argv[1];
    __android_log_print(ANDROID_LOG_INFO, kTag, "checking %s", name);
    AIBinder* binder = AServiceManager_checkService(name);
    if (binder == nullptr) {
        __android_log_print(ANDROID_LOG_WARN, kTag, "%s: not found or not accessible", name);
        return 2;
    }

    AIBinder_decStrong(binder);
    __android_log_print(ANDROID_LOG_INFO, kTag, "%s: found", name);
    return 0;
}
