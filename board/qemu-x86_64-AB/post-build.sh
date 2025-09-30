#!/bin/bash

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"


main() {
    # Append instructions to auto-mount the environment partition
    MOUNT_UBOOT="/dev/vda1       /mnt/uboot      ext2    rw,defaults     0       0"
    if grep -Pq "$MOUNT_UBOOT" "$TARGET_DIR/etc/fstab"; then
        echo "Mounting uboot env already enabled"
    else
        echo "$MOUNT_UBOOT" >> "$TARGET_DIR/etc/fstab"
    fi
    MOUNT_OSTREE="/dev/vda4       /mnt/ostree      ext4    rw,defaults     0       0"
    if grep -Pq "$MOUNT_OSTREE" "$TARGET_DIR/etc/fstab"; then
        echo "Mounting  ostree dev already enabled"
    else
        echo "$MOUNT_OSTREE" >> "$TARGET_DIR/etc/fstab"
    fi

}

main $@
