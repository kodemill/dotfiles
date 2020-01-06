#! /bin/bash
set -o errexit

if [[ $EUID -eq 0 ]]; then
  echo "This script must not be run as root"
  exit 1
fi

dotfiles=${1:-$(readlink -f "$(dirname $0)/../")}

install_dotfiles () {
  echo 'Symlinking dotfiles' $dotfiles
  IFS=$'\n'
  for file in $(find $dotfiles/home -type f ! -path '*.git') ; do
    relative=$(realpath "$file" --relative-to "$dotfiles/home")
    dest="$(realpath ~)/$relative"
    if [ -e $dest ]; then
      backup="$HOME/.dotbackup/$relative"
      mkdir -p $(dirname "$backup")
      mv "$dest" "$backup"
      printf 'backup: %s\n' "$backup"
    fi
    mkdir -p $(dirname "$dest")
    printf 'symlink:'
    ln -svf $(realpath "$file") "$dest"
  done
}

setup_zsh () {
  echo 'Bundling ZSH plugins'
  antibody bundle < $HOME/.config/zsh/zsh_plugins.txt > $HOME/.config/zsh/generated-zsh-plugins.zsh
  antibody update
}

install_fonts () {
  fonts_dir="${HOME}/.local/share/fonts"
  if [ ! -d "${fonts_dir}" ]; then
      echo "mkdir -p $fonts_dir"
      mkdir -p "${fonts_dir}"
  else
      echo "Found fonts dir $fonts_dir"
  fi

  for type in Bold Light Medium Regular Retina; do
      file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
      file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
      if [ ! -e "${file_path}" ]; then
          echo "wget -O $file_path $file_url"
          wget -O "${file_path}" "${file_url}"
      else
    echo "Found existing file $file_path"
      fi;
  done

  echo "fc-cache -f"
  fc-cache -f
}


vscode_extensions_list="$HOME/.config/Code - OSS/User/vscode-extensions.txt"
vscode_extensions_export () { code --list-extensions > $vscode_extensions_list ; }
vscode_extensions_import () {
  empty='^\s*$'
  comment='^\s*\#'
  sed -e "/$empty/d;/$comment/d" ${1:-"$vscode_extensions_list"} |\
  while IFS=, read -r extension ; do
    echo ">> Installing VSCode extension: $extension"
    code --install-extension "$extension"
  done
}

echo 'Installing dotfiles'
install_dotfiles
echo 'Post install scripts'
setup_zsh
vscode_extensions_import
