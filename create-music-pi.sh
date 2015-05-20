#!/bin/bash

# !!! Change to the correct sd-card device !!!
DEV=/dev/sda

# Create partitions
parted -s $DEV mklabel msdos
parted -s $DEV mkpart primary fat16 1049kB 106
parted -s $DEV mkpart primary ext4 106 100%

# Make filesystems
mkfs.fat ${DEV}1
mkfs.ext4 -F ${DEV}2

parted $DEV print

# Mount the SD
mkdir -p root

mount ${DEV}2 root

mkdir -p root/boot

mount ${DEV}1 root/boot

# Download the latest ArchLinuxARM release
wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz

# Extract it to the mounted SD
bsdtar -xvpf ArchLinuxARM-rpi-latest.tar.gz -C root

# Install required packages
arch-install-scripts/pacstrap -c root/ mpd mpc

# Create other required dirs
mkdir -p root/media

# Unmount the SD
umount -R root

# Cleanup the mountpoint
rm -rf root
