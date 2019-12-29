#!/bin/bash

ensure_dir () { mkdir -p $(dirname $1); }

# backup_file () {

# }

backup_dotfiles () {
  for file in $(find $1 -type f ! -path '*.git*') ; do
    relative=$(realpath $file --relative-to $1)
    absolute=$(realpath $file)
    dest="$(realpath $2)/$relative"
    if [ -f $dest ]; then
      backup="$(realpath $3)/$relative"
      ensure_dir $backup
      mv $dest $backup
      printf 'backup:%s -> %s\n' $dest $backup
    fi
    ln -svf $absolute $dest
    printf 'symlink:%s -> %s\n' $dest $absolute
  done
}

backup_dotfiles ./home ~/ ~/.backup
