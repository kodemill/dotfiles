#! /bin/bash
# curl -L https://github.com/kodemill/dotfiles.git
# curl -L http://192.168.191.223:3000/scripts/arch.sh | bash

pacman --noconfirm --needed -S git

# git clone --depth=1 git@github.com:kodemill/dotfiles.git dotfiles
git clone --depth=1 https://github.com/kodemill/dotfiles.git dotfiles

cd dotfiles
bash scripts/install_root.sh
