#!/bin/sh

VMDIR="/home/pistis/vm"

IMGSIZE=40G
RAM=2G
CORES=2
BIOS="$VMDIR/u-boot.bin"
DISK="$VMDIR/9front.qcow2"
RELEASE="9front-11091.arm64"

if [ ! -f $RELEASE.qcow2 ]; then
	wget -c "https://9front.org/iso/$RELEASE.qcow2.gz"
	gunzip -k "$RELEASE.qcow2.gz"
fi

if [ ! -f $DISK ]; then
	qemu-img create -f qcow2 $DISK $IMGSIZE
fi 

qemu-system-aarch64 -M virt-2.12,gic-version=3 \
	-cpu cortex-a72 -m $RAM -smp $CORES \
	-bios $BIOS \
	-drive file=$RELEASE.qcow2,if=none,id=installer \
	-device virtio-blk-pci-non-transitional,drive=installer \
	-drive file=$DISK,if=none,id=disk \
	-device virtio-blk-pci-non-transitional,drive=disk \
	-serial stdio \
	-netdev user,hostfwd=tcp::567-:567,hostfwd=tcp::17019-:17019,id=net0 \
	-device virtio-net-pci-non-transitional,netdev=net0

