SUMMARY = "SWTPM - Software TPM Emulator"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fe8092c832b71ef20dfe4c6d3decb3a8"
SECTION = "apps"

DEPENDS = "libtasn1 expect socat glib-2.0 libtpm libtpm-native"

# configure checks for the tools already during compilation and
# then swtpm_setup needs them at runtime
DEPENDS += "tpm-tools-native expect-native socat-native"
RDEPENDS_${PN} += "tpm-tools"

SRCREV = "073e71f99eaa7a0ff9499339176af1af62c090b2"
SRC_URI = " \
	git://github.com/stefanberger/swtpm.git \
	file://fix_signed_issue.patch \
	file://fix_lib_search_path.patch \
        file://fix_fcntl_h.patch \
        file://ioctl_h.patch \
	"

S = "${WORKDIR}/git"

inherit autotools-brokensep pkgconfig
PARALLEL_MAKE = ""

TSS_USER="tss"
TSS_GROUP="tss"

PACKAGECONFIG ?= "openssl cuse"
PACKAGECONFIG += "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux', '', d)}"
PACKAGECONFIG[openssl] = "--with-openssl, --without-openssl, openssl"
PACKAGECONFIG[gnutls] = "--with-gnutls, --without-gnutls, gnutls"
PACKAGECONFIG[selinux] = "--with-selinux, --without-selinux, libselinux"
PACKAGECONFIG[cuse] = "--with-cuse, --without-cuse, fuse"

EXTRA_OECONF += "--with-tss-user=${TSS_USER} --with-tss-group=${TSS_GROUP}"

export SEARCH_DIR = "${STAGING_LIBDIR_NATIVE}"

# dup bootstrap 
do_configure_prepend () {
	libtoolize --force --copy
	autoheader
	aclocal
	automake --add-missing -c
	autoconf
}

USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM_${PN} = "--system ${TSS_USER}"
USERADD_PARAM_${PN} = "--system -g ${TSS_GROUP} --home-dir  \
    --no-create-home  --shell /bin/false ${BPN}"

RDEPENDS_${PN} = "libtpm expect socat bash"

BBCLASSEXTEND = "native nativesdk"

python() {
    if 'cuse' in d.getVar('PACKAGECONFIG') and \
        'filesystems-layer' not in d.getVar('BBFILE_COLLECTIONS').split():
        raise bb.parse.SkipRecipe('Cuse enabled which requires meta-filesystems to be present.')
}
