include core-image-base.bb


#INITRAMFS_SCRIPTS ?= "\
#                      initramfs-framework-base \
#                      initramfs-module-setup-live \
#                      initramfs-module-udev \
#                      initramfs-module-install \
#                      initramfs-module-install-efi \
#                     "

BASEPACKS = " \
    base-passwd \
    busybox \
    initramfs-framework-base \
    udev \
    ${ROOTFS_BOOTSTRAP_INSTALL} \
"
#initramfs-live-boot
#initramfs-evmkey
#initramfs-framework-ima
#keyutils

#should use package install instead of image install
#maybe INITRAMFS_SCRIPTS
PACKAGE_INSTALL = "${BASEPACKS} ${VIRTUAL-RUNTIME_base-utils}"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

LICENSE = "MIT"


IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

BAD_RECOMMENDATIONS += "busybox-syslog"

#PACKAGE_INSTALL = "${IMAGE_INSTALL}"
