#!/bin/bash
#

echo "unmounting old sd partitions"
sudo umount /dev/mmcblk0*

cd tmp/deploy/images/raspberrypi3/

echo "flashing sd card"
sudo dd if=core-image-base-raspberrypi3.rpi-sdimg of=/dev/mmcblk0 conv=fsync bs=4M

if [ $? -eq 0 ]; then
    echo OK
    sync
    cd ~/rocko/build
else
    echo FAIL
fi
