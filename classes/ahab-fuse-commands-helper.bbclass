## After the device successfully boots a signed image without generating any HAB
## events, it is safe to **secure**, or **"close,"** the device. This is the final
## step in the process. Once the fuse is blown, the chip will **only** load images
## signed with the correct PKI tree.

## Important Notes:
## - This is a **One-Time Programmable (OTP) e-fuse**. Once written,
## it **cannot be undone**, so make sure everything is correct before proceeding.

## - If any of the previous steps were not performed correctly, the SOM
## **will not boot** after this bit is written.

CST_SRK_FUSE ?= "ahab_oem0_srk0_hash.txt"
CST_SRK_FUSE_PATH ?= "${DEPLOY_DIR_IMAGE}/imx-cst/crts/${CST_SRK_FUSE}"
CST_SRK_FUSE_CMDS ?= "${CST_SRK_FUSE}.u-boot-cmds"

print_warning1() {
    echo "# Note: These are One-Time Programmable e-fuses. Once you write them you can't go back, so get it right the first time.
"
}

print_warning2() {
    echo "
# After the device successfully boots a signed image without generating any HAB events, it is safe to secure, or 'close', the device.
# This is the last step in the process. Once the fuse is blown, the chip does not load an image that has not been signed using the correct PKI tree.
# Important notes:
# - This is again a One-Time Programmable e-fuse. Once you write it you can't go back, so get it right the first time.
# - If anything in the previous steps wasn't done correctly, the SOM will not boot after writing this bit.
"
}

fuse_write_line() {
    bank=$1
    word=$2
    value=$3
    echo "fuse prog -y $bank $word $value"
}

create_fuse_cmds_mx8() {
    print_warning1 > ${fuse_log}
    word="$1"
    bank=0
    for i in $(seq 0 15); do
        offset=$(echo "$i * 4" | bc)
        value=$(hexdump -s $offset -n 4  -e '/4 "0x"' -e '/4 "%X""\n"' ${cst_srk_fuse})
        fuse_write_line 0 $word $value >> ${fuse_log}
        word="$(expr $word + 1)"
    done
    print_warning2 >> ${fuse_log}
    echo "ahab_close" >> ${fuse_log}
}

create_fuse_cmds_mx9() {
    print_warning1 > ${fuse_log}
    word=0
    for i in $(seq 0 7); do
        offset=$(echo "$i * 4" | bc)
        value=$(hexdump -s $offset -n 4  -e '/4 "0x"' -e '/4 "%X""\n"' ${cst_srk_fuse})
        fuse_write_line 16 $word $value >> ${fuse_log}
        word="$(expr $word + 1)"
    done
    print_warning2 >> ${fuse_log}
    echo "ahab_close" >> ${fuse_log}
}

create_fuse_cmds_mx95() {
    print_warning1 > ${fuse_log}
    for i in $(seq 0 7); do
        offset=$(echo "$i * 4" | bc)
        value=$(hexdump -s $offset -n 4 -e '/4 "0x"' -e '/4 "%X""\n"' ${cst_srk_fuse})
        fuse_write_line 16 $i $value >> ${fuse_log}
    done
    for i in $(seq 0 7); do
        offset=$(echo "$(expr $i + 8) * 4" | bc)
        value=$(hexdump -s $offset -n 4 -e '/4 "0x"' -e '/4 "%X""\n"' ${cst_srk_fuse})
        fuse_write_line 17 $i $value >> ${fuse_log}
    done
    print_warning2 >> ${fuse_log}
    echo "ahab_close" >> ${fuse_log}
}

create_fuse_cmds() {
    soc="$1"
    cst_srk_fuse="$2"
    cst_srk_fuse_name="$(basename "$cst_srk_fuse")"
    cst_srk_fuse_bin="$(dirname "$cst_srk_fuse")/${cst_srk_fuse_name%.*}.bin"
    fuse_log="$3"
    if [ ! -f $cst_srk_fuse ]; then
        bbfatal "Could not find '$cst_srk_fuse'"
    fi
    xxd -r -p "$cst_srk_fuse" > "$cst_srk_fuse_bin"
    cst_srk_fuse="$cst_srk_fuse_bin"

    case ${soc} in
      mx8x)
        create_fuse_cmds_mx8 730
        ;;
      mx8)
        create_fuse_cmds_mx8 722
        ;;
      mx93|mx91)
        create_fuse_cmds_mx9
        ;;
      mx95)
        create_fuse_cmds_mx95
        ;;
      *)
        bbwarn "Unsupported SOC: ${soc}"
        ;;
    esac
}

do_generate_fuse_cmds() {
    create_fuse_cmds ${SOC_FAMILY} ${CST_SRK_FUSE_PATH} ${UNPACKDIR}/${CST_SRK_FUSE_CMDS}
}
addtask generate_fuse_cmds after do_compile before do_deploy

do_deploy:append() {
    if [ -f ${UNPACKDIR}/${CST_SRK_FUSE_CMDS} ]; then
        install -Dm 0755 ${UNPACKDIR}/${CST_SRK_FUSE_CMDS} ${DEPLOY_DIR_IMAGE}/${CST_SRK_FUSE_CMDS}
    else
        bbwarn "Could not deploy SRK fuse U-Boot commands"
    fi
}
