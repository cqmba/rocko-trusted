CMDLINE_append +="rootflags=i_version ima_appraise=fix ima_policy=tcb ima_policy=appraise_tcb evm=fix audit=0"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux:"

SRC_URI_append += " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'file://tpm2.cfg', '', d)} \
    file://imafix.cfg \
    "
