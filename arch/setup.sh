#! /bin/bash
set -euo pipefail

ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

pacman -Sy --noconfirm archlinux-keyring 
