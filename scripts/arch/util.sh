#! /bin/bash

# Styles
RESET=0
BOLD=1
DIM=2
UNDERLINED=4
BLINK=5
REVERSE=7
HIDDEN=8
# Foreground colors
FG_DEFAULT=39
FG_BLACK=30
FG_RED=31
FG_GREEN=32
FG_YELLOW=33
FG_BLUE=34
FG_MAGENTA=35
FG_CYAN=36
FG_DARK_GRAY=90
# Background colors
BG_DEFAULT=49
BG_BLACK=40
BG_RED=41
BG_GREEN=42
BG_YELLOW=43
BG_BLUE=44
BG_MAGENTA=45
BG_CYAN=46
BG_DARK_GRAY=100

function format_text () {
  local style=$3
  local background=$2
  local foreground=$1
  echo "\e[${style:-$RESET};${background:-$BG_DEFAULT};${foreground:-$FG_DEFAULT}m"
}

function info () {
  echo -e "$(format_text $FG_GREEN $BG_DARK_GRAY $BOLD)[ INFO ]$(format_text) ${1}"
}


# function confirm () {
#   echo keekek
#   local question=${1-"Are you completely sure?"}
#   echo -e "$(format_text $FG_YELLOW $BG_DARK_GRAY $BOLD) $question [y/N]$(format_text)"
#   read response
#   if [[ $response =~ ^([yY][eE][sS]|[yY])+$ ]]
#   then
#     echo 1
#   else
#     echo 0
#   fi
# }
