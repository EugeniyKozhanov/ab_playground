#!/bin/bash

rm -fr ostree-repo
mkdir ostree-repo
cd ostree-repo

debootstrap --arch=amd64 stable os-chroot http://deb.debian.org/debian/

function ostree_commit() {
    local subject=$1
    local branch=$2
    umount os-chroot/proc || echo ignore
    umount os-chroot/sys || echo ignore
    ostree --repo=repo commit --skip-if-unchanged  --branch="$branch" -s "$subject" os-chroot/
    mount proc  none os-chroot/proc -t proc
    mount sysfs none os-chroot/sys  -t sysfs
}

#
# Initialize the ostree repository
#
mount proc os-chroot/proc -t proc
mount proc os-chroot/sys -t sysfs
cp /etc/hosts os-chroot/etc/
rm -fr os-chroot/dev/*
chroot os-chroot/ /bin/bash -c "passwd root -d"
ostree --repo=repo init --mode=archive-z2

ostree_commit "Init commit" main

# Update main branch
chroot os-chroot/ /bin/bash -c "apt install -y vim"
ostree_commit "Install vim" main

chroot os-chroot/ /bin/bash -c "apt install -y nginx"
ostree_commit "Install nginx" webserver

chroot os-chroot/ /bin/bash -c "apt install -y gcc"
ostree_commit "Install gcc" devtools

umount os-chroot/proc
umount os-chroot/sys
rm -fr os-chroot


