CMDLINE_append +="audit=0 ima_appraise=fix ima_policy=tcb ima_policy=appraise_tcb"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux:"

SRC_URI_append += " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'file://tpm2.cfg', '', d)} \
    "

#FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

#SRC_URI_append += " \
#    file://0002-ima-tpm.patch;patchdir=/home/markus/rocko/build/tmp/work/cortexa7hf-neon-vfpv4-poky-linux-gnueabi/linux-libc-headers/4.15.7-r0/linux-4.15.7 \
#    "
