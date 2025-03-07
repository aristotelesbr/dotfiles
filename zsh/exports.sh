export LC_ALL="en_US.UTF-8"
export LANG="en_US"
export EDITOR=${EDITOR:-nvim}
export VISUAL=${VISUAL:-nvim}
export GREP_COLOR="4;33"
export CDPATH=.:$HOME:$HOME/Projects
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export HISTDUP=erase
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export SAVEHIST=1000000000

test-env() {
  export HELLO=hello-there
}

export GPG_TTY=$(tty)

# ASDF
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# EXTRA
export PGGSSENCMODE="disable"

source $HOME/.secrets.sh
