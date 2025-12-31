# Aliases for commonly used commands

# YouTube download cut
ytdlcut() {
  yt-dlp \
    --download-sections "*$1" \
    -f "bestvideo+bestaudio/best" \
    "$2"
}

## YouTube download aliases
#
# Download best video + audio
alias ytdl='yt-dlp -f "bestvideo+bestaudio/best"'
# Download just mp4
alias ytdlmp4='yt-dlp -f bestvideo+bestaudio --merge-output-format mp4'
# Download just mp3
alias ytdlaudio='yt-dlp -f bestaudio --extract-audio --audio-format mp3'
# Download cut (alternative syntax). Usage:
# ytdlcut "00:01:00-00:02:00" https://youtu.be/XXXX
alias ytdlcut='yt-dlp --download-sections "*${1}" -f "bestvideo+bestaudio/best"'

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
alias l="lsd"
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
