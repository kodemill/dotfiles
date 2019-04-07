#! /bin/bash
set -euo pipefail

timestamp=$(date -u +%F-%H-%M-%S)
ui_title="Arch Linux install script"

function getUserAndPassword () {
  user=$(dialog --stdout --backtitle "$ui_title" \
    --title "User dialog" \
    --inputbox "Enter your username" \
    8 60)
  while : ; do
    local pass1=$(dialog --stdout --backtitle "$ui_title" \
      --title "Password dialog" \
      --insecure --passwordbox "Enter your password" \
      8 60)
    local pass2=$(dialog --stdout --backtitle "$ui_title" \
      --title "Password confirmation dialog" \
      --insecure --passwordbox "Re-enter your password" \
      8 60)
    [[ "$pass1" = "$pass2" ]] && break
  done
  password=$pass1
}

function getHostname () {
  hostname=$(dialog --stdout --backtitle "$ui_title" \
    --title "Hostname dialog" \
    --inputbox "Enter the hostname" \
    8 60
  )
}

function getDevice () {
  local devices=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop")
  device=$(dialog --stdout --backtitle "$ui_title" \
    --title "Device selection dialog" \
    --menu "Select installation disk" \
    10 60 0 ${devices})
}

function createPartitions () {
  local boot_start=1
  local boot_size=256
  local boot_end=$(( $boot_start + $boot_size ))
  local swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
  local swap_end=$(( $swap_size +  $boot_end ))
  parted --script "$device" -- \
    mklabel gpt \
    mkpart primary fat32 "${boot_start}MiB" "${boot_end}MiB" \
    set 1 boot on \
    mkpart primary linux-swap "${boot_end}MiB" "${swap_end}MiB" \
    mkpart primary ext4  "${swap_end}MiB" 100%
  part_boot=$(ls ${device}* | grep -E "^${device}p?1$")
  part_swap=$(ls ${device}* | grep -E "^${device}p?2$")
  part_root=$(ls ${device}* | grep -E "^${device}p?3$")
  mkfs.fat -F 32 -n BOOT "$part_boot"
  mkfs.ext4 -F -L root "$part_root"
  mkswap -f -L swap "$part_swap"
}

function rankMirrors () {
  pacman -Sy --noconfirm pacman-contrib
  curl -s "https://www.archlinux.org/mirrorlist/?country=HU" | \
    sed -e 's/^#Server/Server/' -e '/^#/d' | \
    rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
}

getHostname
getUserAndPassword
getDevice

# save stderr & stdout
exec 1> >(tee "stdout_${timestamp}.log")
exec 2> >(tee "stderr_${timestamp}.log")

createPartitions
# mount fs
swapon "${part_swap}"
mount "${part_root}" /mnt
mkdir /mnt/boot
mount "${part_boot}" /mnt/boot

# install
timedatectl set-ntp true
rankMirrors
pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab

echo $hostname > /mnt/etc/hostname

arch-chroot /mnt pacman --noconfirm --needed -S grub efibootmgr
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=boot --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

arch-chroot /mnt useradd -mU -s /usr/bin/bash -G wheel "$user"
# arch-chroot /mnt chsh -s /usr/bin/bash

echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt

# arch-chroot /mnt
