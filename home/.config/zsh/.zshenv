# load profile ignored by X
source $ZDOTDIR/.zprofile

export LANG="en_US.UTF-8"
export LC_ALL=en_US.UTF-8

export EDITOR="code"
export VISUAL="code"
export BROWSER="chromium"
export TERMINAL="kitty"


# load functions
source $ZDOTDIR/.functions
# load aliases
source $ZDOTDIR/.aliases

export EMOJI_CLI_USE_EMOJI="true"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"

export AWS_VAULT_BACKEND="pass"
source "$HOME/.cargo/env"
