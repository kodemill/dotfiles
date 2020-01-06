#!/usr/bin/env bash

# https://github.com/tonsky/FiraCode/wiki/Linux-instructions

isntall_fira_code () {
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


# install_nerd_fonts () {
#   nerd_dir="$HOME/.local/nerd-fonts"
#   if [ ! -d "$nerd_dir" ]; then
#     git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git $nerd_dir
#     cd $nerd_dir
#   else
#     cd $nerd_dir
#     git pull
#   fi
#   fonts=(
#     ""
#   )
# }
