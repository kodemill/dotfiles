#! /bin/bash
set -e

CUR_DIR=$(dirname $(readlink -f $0))
source $CUR_DIR/util.sh

if ( ! whiptail \
  --yesno "This script is meant to be run on VMs.\nIt will erase your disks, are you sure you want to continue?" \
  --title "Continue ?" --defaultno 12 80
) then
  echo 'Exiting...'
  exit 0
fi

# partitions
info "Setting up partitions..."
parted --align=optimal --script /dev/sda \
  mklabel gpt \
  mkpart primary fat32 1MiB 551MiB \
  mkpart primary ext4 551MiB 10GiB \
  mkpart primary linux-swap 10GiB 12GiB \
  mkpart primary ext4 12GiB 100% 1>/dev/null

info "Creating file systems..."
# mkfs.ext4 /dev/sda1 -L boot
mkfs.fat /dev/sda1 -F 32 -n BOOT 1>/dev/null
mkfs.ext4 /dev/sda2 -F -L root 1>/dev/null
mkfs.ext4 /dev/sda4 -F -L home 1>/dev/null
mkswap /dev/sda3 -f -L swap 1>/dev/null
swapon /dev/sda3 1>/dev/null
info "Take a look:"
lsblk -o +label,fstype,uuid

info "Mounting file systems..."
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/home
mount /dev/sda4 /mnt/home

info "Installing packages"
pacstrap /mnt base base-devel
