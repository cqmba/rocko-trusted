#!/bin/bash
#

echo "Loading tpm_tis_spi module"
modprobe tpm_tis_spi

echo "starting tpm2-abrmd"
systemctl start tpm2-abrmd.service

echo "testing getrandom"
tpm2_getrandom 4
