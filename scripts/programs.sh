#! /bin/bash

# DOTFILES=${1:-$(readlink -f "$(dirname $0)/../")}
SRC_HOME=~/.local
BIN_HOME=~/.local/bin  # /usr/local/bin

__fzf () {
  git clone --depth 1 https://github.com/junegunn/fzf.git $SRC_HOME/.fzf
  $SOURCE_HOME/.fzf/install --xdg --key-bindings --completion --no-update-rc --no-bash --no-fish
}

__fasd () {
  sudo add-apt-repository -y ppa:aacebedo/fasd
  sudo apt-get update
  sudo apt-get install -y fasd
}

__antibody () {
# http://getantibody.github.io/
  curl -sfL git.io/antibody | sh -s - -b $BIN_HOME
  antibody bundle < $HOME/.config/zsh/zsh_plugins.txt > $HOME/.config/zsh/generated-zsh-plugins.zsh
  antibody update
}

__rust () {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source ~/.cargo/env
  # echo "export PATH=\"$HOME/.cargo/bin:\$PATH\"" | sudo tee /etc/profile.d/cargo-local.sh
}

__kitty () {
  # https://sw.kovidgoyal.net/kitty/binary.html
  curl -sL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n dest=$SRC_HOME
  ln -sf $SRC_HOME/kitty.app/bin/kitty $BIN_HOME
  cp $SRC_HOME/kitty.app/share/applications/kitty.desktopsudo apt install  ~/.local/share/applications
  sed -i "s#Icon\=kitty#Icon\=$SRC_HOME/kitty.app/share/icons/hicolor/256x256/apps/kitty.png#g" ~/.local/share/applications/kitty.desktop
}

__what () {
  cargo install -q what
  ln -s ~/.cargo/bin/what /usr/local/bin/what
}

__bat () {
  # cargo install -q bat
  # ln -s ~/.cargo/bin/bat /usr/local/bin/bat
  sudo curl -sL https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb -o /tmp/bat.deb
  sudo dpkg -i /tmp/bat.deb
}
