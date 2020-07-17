require ima-evm-utils.inc

#PV = "1.0+git${SRCPV}"
#SRCREV = "3e2a67bdb0673581a97506262e62db098efef6d7"
PV = "1.1+git${SRCPV}"
SRCREV = "c860e0d9bb931da3f586e50a1193cbed970cb1da"
SRC_URI = "git://git.code.sf.net/p/linux-ima/ima-evm-utils"
S = "${WORKDIR}/git"

inherit pkgconfig

FILESEXTRAPATHS_prepend := "${THISDIR}/ima-evm-utils:"

# Documentation depends on asciidoc, which we do not have, so
# do not build documentation.
SRC_URI += "file://disable-doc-creation.patch"

# Workaround for upstream incompatibility with older Linux distros.
# Relevant for us when compiling ima-evm-utils-native.
#SRC_URI += "file://evmctl.c-do-not-depend-on-xattr.h-with-IMA-defines.patch"

# Required for xargs with more than one path as argument (better for performance).
#SRC_URI += "file://command-line-apply-operation-to-all-paths.patch"


#SRC_URI_remove = "file://disable-doc-creation.patch"
#SRC_URI_remove = "file://evmctl.c-do-not-depend-on-xattr.h-with-IMA-defines.patch"
#SRC_URI_remove = "file://command-line-apply-operation-to-all-paths.patch"

SRC_URI += "file://command-line-apply-operation-to-all-paths-v11.patch"
SRC_URI += "file://verify-portable-format.patch"
