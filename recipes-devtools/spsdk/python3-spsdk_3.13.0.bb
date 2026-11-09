SUMMARY = "NXP Secure Provisioning SDK"
HOMEPAGE = "https://github.com/nxp-mcuxpresso/spsdk"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=863e3c0c79e2589ac9d16c3918e115d1"

SRC_URI = "git://github.com/nxp-mcuxpresso/spsdk.git;protocol=https;branch=master \
           file://0002-build-only-the-AHAB-nxpimage-command.patch \
"
SRCREV = "e104adf55184fd6a987d42c506afbce4b9eae807"
SETUPTOOLS_SCM_PRETEND_VERSION = "3.13.0"

DEPENDS += " \
    python3-click-command-tree-native \
    python3-click-native \
    python3-colorama-native \
    python3-crcmod-native \
    python3-cryptography-native \
    python3-asn1crypto-native \
    python3-bitstring-native \
    python3-deepmerge-native \
    python3-fastjsonschema-native \
    python3-filelock-native \
    python3-hexdump-native \
    python3-libusbsio-native \
    python3-platformdirs-native \
    python3-prettytable-native \
    python3-pyasn1-native \
    python3-pycryptodome-native \
    python3-pyserial-native \
    python3-pyyaml-native \
    python3-requests-native \
    python3-ruamel-yaml-native \
    python3-setuptools-scm-native \
    python3-sly-native \
    python3-spsdk-pqc-native \
    python3-t61codec-native \
    python3-typing-extensions-native \
    python3-x690-native \
"

inherit python_setuptools_build_meta

BBCLASSEXTEND = "native"
