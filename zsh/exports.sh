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

export GPG_TTY=$(tty)

# ASDF PATH
eval "$(mise activate zsh)"

# EXTRA
export PGGSSENCMODE="disable"

export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

# Per-machine secrets (GPG_KEY_PERSONAL, tokens, etc.) — gitignored, not
# present on a fresh clone.
[ -f "$XDG_CONFIG_HOME/zsh/secrets.sh" ] && source "$XDG_CONFIG_HOME/zsh/secrets.sh"
