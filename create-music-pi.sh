#!/bin/bash

function create_part_table
{
    parted -s $1 mklabel msdos
    parted -s $1 mkpart primary fat16 1049kB 106
    parted -s $1 mkpart primary ext4 106 100%
}

function make_filesystems
{
    mkfs.fat ${1}1
    mkfs.ext4 -F ${1}2
}

function setup_target
{
    mkdir -p root

    mount ${1}2 root

    mkdir -p root/boot

    mount ${1}1 root/boot
}

function download_latest
{
    wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
}

function install_base
{
    bsdtar -xvpf ArchLinuxARM-rpi-latest.tar.gz -C root
}

function install_packages
{
    arch-install-scripts/pacstrap -c root/ $*
}

function install_extra
{
    mkdir -p root/media
}

function cleanup_target
{
    # Unmount the SD
    umount -R root

    # Cleanup the mountpoint
    rm -rf root
}

function all
{
    create_part_table $1
    make_filesystems $1
    setup_target $1
    download_latest
    install_base
    install_packages mpd mpc
    install_extra
    cleanup_target
}

# !!! Change to the correct sd-card device !!!
DEV=/dev/sda

all $DEV
