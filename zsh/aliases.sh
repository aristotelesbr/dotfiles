# Aliases for commonly used commands

# Re-exec instead of re-sourcing: sourcing ~/.zshrc de novo roda compinit e o
# oh-my-zsh uma segunda vez em cima do estado atual.
alias reload="exec zsh"

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Listing. lsd é opcional (brew install lsd) — sem esse fallback, numa máquina
# recém-instalada `l` fica quebrado até alguém lembrar de instalar.
if command -v lsd >/dev/null 2>&1; then
  alias l="lsd -l"
  alias la="lsd -la"
else
  alias l="ls -lh"
  alias la="ls -lah"
fi

# Shortcuts
alias h="history"
alias j="jobs"
alias c="clear"

# Git. O plugin git do oh-my-zsh já define g, ga, gb, gd e gc (esse último com
# --verbose, que é melhor), então só fica aqui o que ele não cobre com esse nome.
# Atenção: `gs` sombreia o binário do ghostscript — use `command gs` pra ele.
alias gs="git status"

# Create a new file and edit it
function mkf() {
  touch "$@" && $EDITOR "$@"
}
