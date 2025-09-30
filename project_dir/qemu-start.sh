#!/bin/bash
VM_NAME="qemu-x86_64-ab"

echo "Copying new image"
DISK_SRC=$(realpath ./images/qemu.img)
DISK_CPY=$(mktemp -d --suffix=$VM_NAME)
#delete old copies of the disk
rm -rf "/tmp/*$VM_NAME"
#We create a temporary disk-image, this removes the need
#to regenerate a clean disk image with Buildroot each time
cp "$DISK_SRC" "$DISK_CPY"

DISK="$DISK_CPY/qemu.img"

#Find U-boot rom
UBOOT=$(realpath ./images/u-boot.rom)
QEMU_ARGS=(
    -name "$VM_NAME"
    -smp sockets=1,cores=1
    -m 128
    -overcommit mem-lock=off
    -rtc base=utc,driftfix=slew
    -k fr-be #or whatever you want ;)
    -nographic
    -device virtio-rng-pci
    -object rng-random,id=objrng0,filename=/dev/urandom
    -drive id=disk0,file=$DISK,if=none,cache=directsync,format=raw,snapshot=off
    -device virtio-blk-pci,drive=disk0
    -bios $UBOOT #This is important, this allows us to use our own bootloader
    -machine pc
    -netdev user,id=veth0
	  -device driver=virtio-net,netdev=veth0
)
echo "qemu-system-x86_64 ${QEMU_ARGS[@]}"
qemu-system-x86_64 "${QEMU_ARGS[@]}"
