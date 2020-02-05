DESCRIPTION = "Testing Bitbake file"
SECTION = "TESTING"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r0"

SRC_URI += "file://*"

#specify where to get the files
S = "${WORKDIR}"

inherit allarch

#create the folder in target machine
#${D} is the directory of the target machine
#move the file from working directory to the target machine


do_install() {
    install -d ${D}/home/root/scripts
    install -d ${D}/home/root/scripts/csr
    install -d ${D}/home/root/scripts/ek_cert
    install -d ${D}/home/root/scripts/nv
    install -d ${D}/home/root/scripts/pcr_auth
    install -d ${D}/home/root/scripts/performance_tests
    install -d ${D}/home/root/scripts/permanent
    install -d ${D}/home/root/scripts/raw_commands
    install -d ${D}/home/root/scripts/sealing
    install -d ${D}/home/root/scripts/sessions
    install -d ${D}/home/root/scripts/signature
    cp -r ${WORKDIR}/csr/* ${D}/home/root/scripts/csr
    cp -r ${WORKDIR}/ek_cert/* ${D}/home/root/scripts/ek_cert
    cp -r ${WORKDIR}/nv/* ${D}/home/root/scripts/nv
    cp -r ${WORKDIR}/pcr_auth/* ${D}/home/root/scripts/pcr_auth
    cp -r ${WORKDIR}/performance_tests/* ${D}/home/root/scripts/performance_tests
    cp -r ${WORKDIR}/permanent/* ${D}/home/root/scripts/permanent
    cp -r ${WORKDIR}/raw_commands/* ${D}/home/root/scripts/raw_commands
    cp -r ${WORKDIR}/sealing/* ${D}/home/root/scripts/sealing
    cp -r ${WORKDIR}/sessions/* ${D}/home/root/scripts/sessions
    cp -r ${WORKDIR}/signature/* ${D}/home/root/scripts/signature
    cp -r ${WORKDIR}/tpm2_start.sh ${D}/home/root/scripts
    cp -r ${WORKDIR}/getconfig.sh ${D}/home/root/scripts
    cp -r ${WORKDIR}/test_tpmextend.sh ${D}/home/root/scripts
    install -d ${D}/etc/udev/rules.d
    install -m 0644 ${WORKDIR}/tpm-udev.rules ${D}/etc/udev/rules.d/50-tpm-udev.rules
}

FILES_${PN} += "\
/etc/udev/rules.d/50-tpm-udev.rules \
/home/root/* \
"
