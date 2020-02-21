#!/bin/sh

# replace the filesystem type with what you're using
root # export FS=ext4
# sign all executable files owned by root
root # /usr/bin/find / -fstype $FS -type f -executable -uid 0 -exec evmctl -a sha256 ima_sign -pmypass -k /root/certs/ima_priv.pem '{}' \;
# sign all libraries which don't carry an executable bit
root # for D in /lib /lib64 /usr/lib /usr/lib64; do
    /usr/bin/find "$D" -fstype $FS -\! -executable -type f -name "*.so*" -uid 0 -exec evmctl -a sha256 ima_sign -pmypass -k /root/certs/ima_priv.pem '{}' \;
done
# also sign kernel modules
root # /usr/bin/find /lib/modules -fstype $FS -type f -name "*.ko" -uid 0 -exec evmctl -a sha256 ima_sign -pmypass -k /root/certs/ima_priv.pem '{}' \;
# also sign firmware files
root # /usr/bin/find /lib/firmware -fstype $FS -type f -uid 0 -exec evmctl -a sha256 ima_sign -pmypass -k /root/certs/ima_priv.pem '{}' \;

