#! /bin/bash

set -o errexit

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

username=${1:-'vbox'}
dotfiles=${2:-$(readlink -f "$(dirname $0)/../")}
logfile=${3:-'out.log'}
echo $logfile

separator='========================================================================================================='
log () {
  echo -e "\n$separator\n[$(date --rfc-3339=ns)]$1\n$separator" >> $logfile
}

install_programs () {
  # 1st parameter is a csv: separator(,) delimiter(")
  # filter empty and comment lines, remove " and any whitespaces near them
  empty='^\s*$'
  comment='^\s*\#'
  total=$(cat $1 | grep -v $empty | grep -v $comment | wc -l)

  sed -e "/$empty/d;/$comment/d;s/\s*\"\s*//g" $1 |\
  while IFS=, read -r name description program mode; do
    i=$((i+1))
    message="\n[$i/$total] Installing $name program\n$description"
    log "$message"
    case $mode in
      bash)
        install_method=install_program_bash
        ;;
      pac*)
        install_method=install_program_pacman
        ;;
      *)
        install_method=install_program_yay
        ;;
    esac
    $install_method $program | tee -a $logfile | \
      dialog \
        --clear \
        --scrollbar \
        --backtitle "${2:-'Arch customization script'}" \
        --title "Please wait while installing programs from $1" \
        --progressbox "$message" 35 160
        # --begin 3 3 \
  done
}
install_program_bash () { bash -c "'$1'" ; }
install_program_pacman () { pacman --noconfirm --needed -S "$1" ; }
install_program_yay () { sudo -u "$username" yay --noconfirm -S "$1" ; }

setup_user () {
  if ! getent passwd $username > /dev/null 2>&1; then
    useradd -mU -s /usr/bin/bash -G wheel "$username"
  fi
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-wheel
}

setup_pacman () {
  grep "^Color" /etc/pacman.conf >/dev/null || sed -i "s/^#Color/Color/" /etc/pacman.conf
  sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf
}

set_shell () {
  sed -i "s/^$username:\(.*\):\/bin\/.*/$username:\1:\/bin\/zsh/" /etc/passwd
}

log 'Script start\n'
log 'Setting up user'
setup_user
log 'Installing base programs'
install_program_pacman dialog
install_programs $dotfiles/packages/prog-base.csv 'Installing base programs'
# log 'Pacman setup'
# setup_pacman
log 'Preparing development environment'
install_programs $dotfiles/packages/prog-dev.csv 'Preparing development environment'
clear
log 'Running user setup'
sudo -u "$username" $dotfiles/scripts/install_user.sh | tee -a $logfile | \
      dialog \
        --clear \
        --scrollbar \
        --backtitle 'Arch customization script' \
        --title "Running user setup: $1" \
        --progressbox "$message" 35 160
clear
log 'Setting shell for user'
set_shell

