SUMMARY = "Post-quantum cryptography support for SPSDK"
HOMEPAGE = "https://github.com/nxp-mcuxpresso/spsdk_plugins"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fe2a425fb1f291c670f58b9e3771878e"

PYPI_PACKAGE = "spsdk_pqc"
SRC_URI[sha256sum] = "1b3b98cd9f82e1e435ba2a76fa9623fd6620d4ef93ca3871185492c23c824ab8"

DEPENDS += "cmake-native python3-click-native python3-pyasn1-native python3-pycryptodome-native"

inherit pypi python_setuptools_build_meta

BBCLASSEXTEND = "native"
