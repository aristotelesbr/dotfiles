export DOTFILES_LOADED="true"
export SHELL_NAME="zsh"
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

typeset -U path PATH
autoload -Uz compinit
autoload -Uz add-zsh-hook
compinit -i

zsh_dir=$XDG_CONFIG_HOME/zsh

source $zsh_dir/exports.sh
# source $zsh_dir/oh-my-zsh.sh
# source $zsh_dir/starship.sh
# source $zsh_dir/tmux.sh
# source $zsh_dir/aliases.sh
# source $zsh_dir/ssh.sh
# source $zsh_dir/fzf.sh
source $zsh_dir/bitwarden.sh
