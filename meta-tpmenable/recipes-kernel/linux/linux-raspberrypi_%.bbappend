CMDLINE_append +="ima_appraise=fix ima_policy=tcb ima_policy=appraise_tcb"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux:"

SRC_URI_append += " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'file://tpm2.cfg', '', d)} \
    file://ourfix.patch \
    "
