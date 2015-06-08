#!/bin/bash

# import core funcs
. core.sh

function install_system
{
    # Install required packages
    install_packages mpd mpc
    # Create extra required directories
    mkdir -p root/media
}

main $*