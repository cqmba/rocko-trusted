#!/bin/bash
#

echo "Enabling configs"
modprobe configs

echo "Unpacking into running.conf"
cat /proc/config.gz | gunzip > running.conf

echo "You can check with cat running.conf | grep CONFIG_.... "
