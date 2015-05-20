# arch-pi-strap
A very simple shell script that creates an Arch Linux ARM installation for the Raspberry Pi on an SD card.

## required packages
- [parted](https://www.archlinux.org/packages/?q=parted)
- [dosfstools](https://www.archlinux.org/packages/?q=dosfstools)
- [wget](https://www.archlinux.org/packages/?q=wget)

## setup

On an existing ArchLinux ARM installation start by cloning the project
```
$ git clone https://github.com/Nimdraug/arch-pi-strap.git
$ cd arch-pi-strap/
```

Then build the arch install scripts provided in a submodule.
This provides the required pacstrap script
```
$ cd arch-install-scripts/
$ make
$ cd ..
```

Set the `DEV` variable in the script to your SD-card's device.
Make sure this is the correct device or you might break your host system.
```
DEV=/dev/sdX
```

Then run the script

## note
This script has the potential to break host system and cause all your files to disappear. Please use with caution.
The creator of the script cannot be held accontable for any damages caused by the script.

## future
Currently the script creates an mpd based music player system. Later the script will become more generic and allow for all sorts of setups.
It will also be more modular and allow for specific actions to be run so for instance it will be able to just install the base system if the partitions are already setup instead of completely recreating them every time.