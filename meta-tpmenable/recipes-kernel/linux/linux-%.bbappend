#CMDLINE_append +="ima_tcb ima_appraise_tcb"
#CMDLINE_append +="ima_policy=tcb"

#FILESEXTRAPATHS_prepend += "/home/markus/rocko/meta-tpmenable/recipes-kernel/linux/linux:"
#SRC_URI_append = "file://imafix.cfg"

#do_configure_append () {
#    ${S}/scripts/kconfig/merge_config.sh -m -O ${WORKDIR}/build ${WORKDIR}/build/.config ${WORKDIR}/*.cfg
#}

#do_configure_append() {
#    cat ${WORKDIR}/ima.cfg >> ${B}/.config
#}

FILESEXTRAPATHS_prepend := "${THISDIR}/linux:"

# Enable tpm in kernel 
#SRC_URI_append_x86 = " \
#    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm', 'file://tpm.scc', '', d)} \
#    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'file://tpm2.scc', '', d)} \
#    "

#SRC_URI_append_x86-64 = " \
#    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm', 'file://tpm.scc', '', d)} \
#    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'file://tpm2.scc', '', d)} \
#    "

#SRC_URI += " \
#    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm_i2c', 'file://tpm_i2c.scc', '', d)} \
#    ${@bb.utils.contains('MACHINE_FEATURES', 'vtpm', 'file://vtpm.scc', '', d)} \
#    "

SRC_URI_append += " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'file://tpm2.cfg', '', d)} \
    "
