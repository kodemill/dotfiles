#!/bin/bash

DOTFILES=${1:-$(readlink -f "$(dirname $0)/../")}

install_dotfiles () {
  echo 'Symlinking dotfiles' $DOTFILES
  for file in $(find $DOTFILES/home -type f ! -path '*.git*') ; do
    relative=$(realpath $file --relative-to "$DOTFILES/home")
    dest="$(realpath ~)/$relative"
    if [ -e $dest ]; then
      backup="$(realpath $1)/$relative"
      mkdir -p $(dirname $backup)
      mv $dest $backup
      printf 'backup: %s\n' $backup
    fi
    mkdir -p $(dirname $dest)
    printf 'symlink:'
    ln -svf $(realpath $file) $dest
  done
}

# git_clone () {

# }

install_dotfiles  ~/.backup

# numlines=$(tput lines)
# numcols=$(tput cols)
# numcols=$(expr $numcols - 1)
# separator_line=$(for i in $(seq 0 $numcols);do printf "%s" "-";done;printf "\n")
# tput cup $numlines
# echo $separator_line
# echo ===
# sleep 1
# tput cup $numlines
# echo $separator_line
# echo =====
# sleep 1
# tput cup $numlines
# echo $separator_line
# echo =======
# sleep 1
# tput cup $numlines
# echo $separator_line
# echo =========
# sleep 1
# tput cup $numlines
# echo $separator_line
# echo ===========
