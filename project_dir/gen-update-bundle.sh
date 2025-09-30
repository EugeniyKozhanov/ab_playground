#!/bin/bash

rm -f update.raucb
rm -f sdcard.img
rm -rf bundle

mkdir bundle
cd bundle

echo '
[update]
compatible=abtest

[bundle]
format=verity

[image.rootfs]
filename=rootfs.ext4
' > manifest.raucm

cp ../images/rootfs.ext4 .
udisksctl loop-setup --file rootfs.ext4
#Output: Mapped file rootfs.ext4 as /dev/loop0.
udisksctl mount -b /dev/loop0
#Output: Mounted /dev/loop0 at /media/$USER/rootfs


sudo bash -c "echo '2.0' > /media/$USER/rootfs/usr/var/abtest/version"


udisksctl unmount -b /dev/loop0
udisksctl loop-delete -b /dev/loop0

cd ../
./host/bin/rauc bundle -d --cert=./demo.cert.pem --key=./demo.key.pem ./bundle update.raucb

IMG="sdcard.img"
SIZE_MB="1024"
SRCFILE="update.raucb"

qemu-img create -f raw "$IMG" ${SIZE_MB}M

mkfs.ext4 -F "$IMG"

TMPDIR=$(mktemp -d)
sudo mount -o loop "$IMG" "$TMPDIR"

sudo cp "$SRCFILE" "$TMPDIR/"

sync
sudo umount "$TMPDIR"
rmdir "$TMPDIR"

echo "Use QEMU monitor to flash the update bundle:"
echo "  (qemu) drive_add 1 file=sdcard.img,if=none,id=sdcard,format=raw"
echo "  (qemu) device_add virtio-blk-pci,drive=sdcard,id=mysd"
echo " To delete the device again, use:"
echo "  (qemu) device_del mysd"
echo "You can find device in the VM as /dev/vdb"
