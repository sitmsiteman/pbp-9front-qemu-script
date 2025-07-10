#!/bin/sh

VMDIR="/home/pistis/vm"

IMGSIZE=40G
RAM=2G
CORES=2
BIOS="$VMDIR/u-boot.bin"
DISK="$VMDIR/9front.qcow2"

qemu-system-aarch64 -M virt-2.12,gic-version=3,accel=kvm \
	-cpu host -m $RAM -smp $CORES \
	-bios $BIOS \
	-drive file=$DISK,if=none,id=disk \
	-device virtio-blk-pci-non-transitional,drive=disk \
	-serial stdio \
	-netdev user,hostfwd=tcp::567-:567,hostfwd=tcp::17019-:17019,id=net0 \
	-device virtio-net-pci-non-transitional,netdev=net0

