# Aliases for commonly used commands

# reload .zshrc
alias reload="source ~/.zshrc"

# Easier navigation: .., ..., ~ and -Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Shortcuts
alias h="history"
alias j="jobs"
alias c="clear"
alias l="ls -l"
alias la="ls -la"

# List all files colorized in long format
alias tail='colortail'

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"

# Docker
alias d="docker"
alias dc="docker-compose"
alias dcd="docker-compose down"
alias dcr="docker-compose run"
alias dce="docker-compose exec"
alias dcb="docker-compose build"
alias dcl="docker-compose logs"
alias dcp="docker-compose ps"

# Create a new file and edit it
function mkf() {
  touch "$@" && $EDITOR "$@"
}
