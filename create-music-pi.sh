#!/bin/bash
# Create partitions
DEV=/dev/sda

parted -s $DEV mklabel msdos
parted -s $DEV mkpart primary fat16 1049kB 106
parted -s $DEV mkpart primary ext4 106 100%

mkfs.fat ${DEV}1
mkfs.ext4 -F ${DEV}2

parted $DEV print

mkdir -p root

mount ${DEV}2 root

mkdir -p root/boot

mount ${DEV}1 root/boot

wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz

bsdtar -xvpf ArchLinuxARM-rpi-latest.tar.gz -C root

arch-install-scripts/pacstrap -c root/ mpd mpc

mkdir -p root/media

umount -R root

rm -rf root
