#! /bin/bash
set -euo pipefail

pacman -Sy --noconfirm archlinux-keyring
pacman --noconfirm --needed -S grub efibootmgr intel-ucode
grub-install --target=x86_64-efi --efi-directory=boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

hostname=$(hostname)
cat > test <<EOF
127.0.0.1     localhost.localdomain       localhost
::1           localhost.localdomain       localhost
127.0.1.1     $hostname.localdomain       $hostname
EOF
