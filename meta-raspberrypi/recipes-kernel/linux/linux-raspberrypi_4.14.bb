LINUX_VERSION ?= "4.14.84"

SRCREV = "c28ac2dc08bd73963f953a757a3362c64b5524ed"
SRC_URI = " \
    git://github.com/raspberrypi/linux.git;branch=rpi-4.14.y \
    file://0001-menuconfig-check-lxdiaglog.sh-Allow-specification-of.patch \
    "

require linux-raspberrypi.inc
