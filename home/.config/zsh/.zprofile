
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

# android sdk
# export ANDROID_HOME=$HOME/Android/Sdk
# export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH=$PATH:$ANDROID_HOME/tools
# export PATH=$PATH:$ANDROID_HOME/tools/bin
# export PATH=$PATH:$ANDROID_HOME/platform-tools

if [ -d "$HOME/go/bin" ] ; then
  PATH="$PATH:$HOME/go/bin"
fi
