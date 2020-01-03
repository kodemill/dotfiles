#! /bin/bash

# DOTFILES=${1:-$(readlink -f "$(dirname $0)/../")}
SRC_HOME=~/.local
BIN_HOME=~/.local/bin  # /usr/local/bin


__rust () {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source ~/.cargo/env
  # echo "export PATH=\"$HOME/.cargo/bin:\$PATH\"" | sudo tee /etc/profile.d/cargo-local.sh
}

__what () {
  cargo install -q what
  ln -s ~/.cargo/bin/what /usr/local/bin/what
}
