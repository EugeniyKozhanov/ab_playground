#!/bin/sh

openssl req -x509 -newkey rsa:4096 -nodes -keyout demo.key.pem -out demo.cert.pem -subj "/O=rauc Inc./CN=rauc-demo"
mkdir -p ../board/qemu-x86_64-AB/overlay/usr/var/rauc/
cp demo.cert.pem ../board/qemu-x86_64-AB/overlay/usr/var/rauc/rauc-cert.pem

mkdir -p ../board/qemu-x86_64-AB/overlay/usr/var/abtest
echo "1.0" > ../board/qemu-x86_64-AB/overlay/usr/var/abtest/version

