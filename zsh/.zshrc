# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# History configuration
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

# Plugins
plugins=(
  git
  asdf
  zsh-autosuggestions
  zsh-syntax-highlighting
  bundler
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load custom exports
if [ -f ~/.zsh/exports.sh ]; then
  source ~/.zsh/exports.sh
else
  echo "Arquivo de exports não encontrado: ~/.zsh/exports.sh"
fi

# TMUX configuration
if [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
  echo "TMUX is ready to go"
  echo "To start a new session, type 'tmux new-session -A -s main'"
fi

# SSH Agent configuration
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
fi

# GPG configuration
export GPG_TTY=$(tty)
if [ -n "${SSH_CONNECTION}" ]; then
    export PINENTRY_USER_DATA="USE_CURSES=1"
fi

# Initialize Starship prompt
eval "$(starship init zsh)"
