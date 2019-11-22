RPIFW_DATE = "20180619"
SRCREV = "469f2d8eb88a4ef71f77d4912b8f15ba3a7dd57b"
SRC_URI[md5sum] = "3baa6484052ae6b0d4f5272788b3ae83"
SRC_URI[sha256sum] = "9769d0d8243a818cb09711a020a40e8b4d3437b565bd9df709a866694097e9c7"

RPIFW_SRC_URI = "https://codeload.github.com/raspberrypi/firmware/tar.gz/${SRCREV}"
RPIFW_S = "${WORKDIR}/firmware-${SRCREV}"

do_unpack() {
    tar -C ${WORKDIR} -xzf ${DL_DIR}/${SRCREV}
}
