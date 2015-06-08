# arch-pi-strap
A collection of simple shell scripts that create various Arch Linux ARM installations on an SD card for the Raspberry Pi.

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

## usage

To install a system on an SD card you need to run one of the provided system setup scripts (currently only two provided).
```
system-setup-script device [ command ]
```
*device* is the block device for the SD card you wish to install the system on. Make sure it is not the one your current system is on incase it gets overwritten.

If no *command* is given the script will enter interactive mode and you will be asked what actions you wish to execute using yes and no questions.

commands:
- create-part-table: creates a partition table to the card using parted. *Note*: The partitions will not be formatted.
- make-filesystems: formats the partitions to create the required filesystems
- install-base: downloads the latest version of Archlinux ARM that is available an installs it on the card. If a version has already been downloaded you will be asked if you wish to overwrite it.
- install-system: installs system specific packages and files to get the desired system up quicker

## available system setup scripts

- create-base-pi.sh: this just installs the base system, nothing else. This one can actually be run from any Archlinux system, not just a Archlinux ARM one, and is therefore good for getting started.
- create-music-pi.sh: this installs a [mpd](http://www.musicpd.org/) server along with client as well as the base system for use as a music player system

## custom system setup scripts
You can create your own system setup scripts by importing the core functions
```
. core.sh
```
then override the `install_system` function to apply your system specific stuff. This function is run with the target system's filesystems mounted at `./root` which is where you need to put any system specific files such as configs in `./root/etc`.
Run `install_packages` with a list of packages as it's attributes to install any packages required by the system.

## note
These scripts have the potential to break host system and cause all your files to disappear. Please use with caution.
The creator of the scripts cannot be held accontable for any damages caused by the script.
