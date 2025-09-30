#!/bin/bash

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"


main() {
	#find uboot-tools
	pushd ${BUILD_DIR}
	U_BOOT_TOOLS=$(find -maxdepth 1 -type d -name "host-uboot-tools-*")
	if [ -z "$U_BOOT_TOOLS" ]; then
		echo "ERROR: Could not find host uboot-tools"
		exit 1
	fi
	U_BOOT_TOOLS=$(realpath $U_BOOT_TOOLS/tools)
	popd


	#Buildroot compiles the script automatically, and outputs it in host-uboot-tools
	#To refresh the script, rebuild host-uboot-tools.
	cp $U_BOOT_TOOLS/boot.scr ${BINARIES_DIR}/boot.scr

	#Build a filesystem for our compiled script
	mkdir -p ${BUILD_DIR}/tmproot
	cp ${BINARIES_DIR}/boot.scr ${BUILD_DIR}/tmproot/
	rm -f ${BINARIES_DIR}/boot.ext2
	mkfs.ext4 -d ${BUILD_DIR}/tmproot -t ext2 -r 1 -N 0 -m 5 -L "boot" -I 256 -O ^64bit,^metadata_csum ${BINARIES_DIR}/boot.ext2 "1M"
	rm -r ${BUILD_DIR}/tmproot

	#Build a filesystem for OSTree
	mkdir -p ${BUILD_DIR}/tmproot-ostree
	cp -r ${BINARIES_DIR}/../ostree-repo ${BUILD_DIR}/tmproot-ostree/
	rm -f ${BINARIES_DIR}/ostree.ext4
	mkfs.ext4 -d ${BUILD_DIR}/tmproot-ostree -t ext4 -L "ostree" ${BINARIES_DIR}/ostree.ext4 "4024M"
	rm -r ${BUILD_DIR}/tmproot-ostree

	#Generating the image according to the layout given in the genimage.cfg
	support/scripts/genimage.sh -c "${BOARD_DIR}/genimage.cfg"
	exit $?
}

main $@
