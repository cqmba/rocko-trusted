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
