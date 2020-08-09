
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# add cargo binaries to PATH
if [ -d "$HOME/.cargo/bin" ] ; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.local/kitty.app" ] ; then
  PATH="$HOME/.local/kitty.app/bin:$PATH"
fi

# if [ -d /home/linuxbrew/.linuxbrew ] ; then
#   eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# fi

export PATH="$HOME/.cargo/bin:$PATH"
