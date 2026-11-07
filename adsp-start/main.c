#include <fcntl.h>
#include <linux/magic.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/statfs.h>
#include <sys/statvfs.h>
#include <unistd.h>

#define FIRMWARE_MOUNT "/vendor/firmware_mnt"
#define ADSP_NAME "/sys/class/remoteproc/remoteproc0/name"
#define ADSP_STATE "/sys/class/remoteproc/remoteproc0/state"
#define ADSP_BOOT "/sys/kernel/boot_adsp/boot"

static int read_value(const char *path, char *value, size_t size) {
    int fd = open(path, O_RDONLY | O_CLOEXEC);
    if (fd < 0) return -1;
    ssize_t count = read(fd, value, size - 1);
    close(fd);
    if (count <= 0) return -1;
    value[count] = '\0';
    value[strcspn(value, "\n")] = '\0';
    return 0;
}

static int firmware_ready(const char *path, dev_t device) {
    struct stat st;
    int fd = open(path, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
    if (fd < 0) return 0;
    int ready = fstat(fd, &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0 &&
                st.st_dev == device;
    close(fd);
    return ready;
}

int main(int argc, char **argv) {
    if (argc != 2 || (strcmp(argv[1], "_a") && strcmp(argv[1], "_b"))) return 1;

    struct stat mount_st;
    struct statfs fs;
    struct statvfs vfs;
    if (stat(FIRMWARE_MOUNT, &mount_st) || statfs(FIRMWARE_MOUNT, &fs) ||
        statvfs(FIRMWARE_MOUNT, &vfs) || fs.f_type != EXT4_SUPER_MAGIC ||
        (vfs.f_flag & (ST_RDONLY | ST_NOSUID | ST_NODEV)) !=
                (ST_RDONLY | ST_NOSUID | ST_NODEV)) return 2;

    if (!firmware_ready(FIRMWARE_MOUNT "/image/adsp.mdt", mount_st.st_dev) ||
        !firmware_ready(FIRMWARE_MOUNT "/image/adsp_dtb.mdt", mount_st.st_dev)) return 3;

    char value[80];
    if (read_value(ADSP_NAME, value, sizeof(value)) ||
        strcmp(value, "3000000.remoteproc-adsp")) return 4;
    if (!read_value(ADSP_STATE, value, sizeof(value)) && !strcmp(value, "running")) return 0;

    int fd = -1;
    for (int i = 0; i < 100 && fd < 0; ++i) {
        fd = open(ADSP_BOOT, O_WRONLY | O_CLOEXEC);
        if (fd < 0) usleep(100000);
    }
    if (fd < 0) return 5;
    ssize_t written = write(fd, "1", 1);
    int closed = close(fd);
    if (written != 1 || closed) return 6;

    for (int i = 0; i < 300; ++i) {
        if (!read_value(ADSP_STATE, value, sizeof(value)) && !strcmp(value, "running"))
            return 0;
        usleep(100000);
    }
    return 7;
}
