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

function install_base_with_download_check
{
    [ ! -e "ArchLinuxARM-rpi-latest.tar.gz" ] &&
        download_latest || {
            read -p "Re-download latest base (y/n)?"
            [ "$REPLY" == "y" ] && {
                rm -f "ArchLinuxARM-rpi-latest.tar.gz"
                download_latest
            }
        }
    install_base
}

function install_packages
{
    arch-install-scripts/pacstrap -c root/ $*
}

function install_system
{
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
    read -p "Create Partitions (y/n)?"
    [ "$REPLY" == "y" ] && create_part_table $1
    read -p "Make Filesystems (y/n)?"
    [ "$REPLY" == "y" ] && make_filesystems $1
    setup_target $1
    read -p "Install Base (y/n)?"
    [ "$REPLY" == "y" ] && {
        install_base_with_download_check
    }
    read -p "Install System (y/n)?"
    [ "$REPLY" == "y" ] && {
        install_system
    }
    cleanup_target
}

function main
{
    [ $# -gt 0 ] && {
        [ $# -gt 1 ] && {
            case $2 in
                create-part-table)
                    create_part_table $1;;
                make-filesystems)
                    make_filesystems $1;;
                install-base | install-system)
                {
                    setup_target $1
                    if [ $2 == "install-base" ]
                    then
                        install_base_with_download_check
                    else
                        install_system
                    fi
                    cleanup_target
                };;
                *)
                    echo 'unkown command: $2';;
            esac
        } || {
            all $1
        }
    } || {
        echo "usage: $0 device [ command ]"
    }
}
