SUMMARY = "IMA module for the modular initramfs system"
LICENSE = "MIT"
#LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
RDEPENDS_${PN} += "initramfs-framework-base"

#FILESEXTRAPATHS =. "${IMA_EVM_BASE}/data:"

#SRC_URI = " \
#    file://${IMA_POLICY} \
#    file://ima \
#"

do_install () {
    echo "EVM test initramfs"
    keyctl add user kmk-user "`dd if=/dev/urandom bs=1 count=32 2>/dev/null`" @u
    keyctl add encrypted evm-key "new user:kmk-user 64" @u
}

#FILES_${PN} = "/init.d ${sysconfdir}"
RDEPENDS_${PN} = "keyutils"
