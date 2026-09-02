#!/usr/bin/env bash
#
# Dotfiles installer
#
# Puts each part of this repo where the corresponding tool looks for it.
# By default it creates symlinks, so editing a file in the repo takes effect
# right away and `git status` still sees your changes. Use --copy for loose
# copies instead.
#
# Static config that already exists at the destination isn't deleted: it's
# moved to ~/.dotfiles-old/ with an -old suffix (e.g. nvim -> ~/.dotfiles-old/nvim-old).
# Regenerable artifacts left by previous configs (lazy.nvim plugins, mason,
# TPM, caches, zcompdump) are removed in the cleanup phase, with confirmation.
#
#   ./install.sh                 # install everything (configs, shell, fonts, cleanup)
#   ./install.sh --dry-run       # show what it would do, without changing anything
#   ./install.sh --copy          # copy instead of symlinking
#   ./install.sh --no-fonts      # skip font installation
#   ./install.sh --no-clean      # skip residual cleanup
#   ./install.sh --yes           # don't ask anything (for automation)
#   ./install.sh --config-home D # use D instead of ~/.config

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
OLD_DIR="$HOME/.dotfiles-old"

MODE="link"
DRY_RUN=false
WITH_FONTS=true
WITH_CLEAN=true
ASSUME_YES=false

if [ -t 1 ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'; GREEN=$'\033[32m'
  YELLOW=$'\033[33m'; BLUE=$'\033[34m'; RESET=$'\033[0m'
else
  BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; RESET=""
fi

info() { printf '\n%s\n' "${BLUE}==>${RESET} ${BOLD}$*${RESET}"; }
ok()   { printf '    %s %s\n' "${GREEN}✓${RESET}" "$*"; }
skip() { printf '    %s %s\n' "${DIM}–${RESET}" "${DIM}$*${RESET}"; }
warn() { printf '    %s %s\n' "${YELLOW}!${RESET}" "$*"; }
die()  { printf '%s %s\n' "${RED}✗${RESET}" "$*" >&2; exit 1; }

usage() { sed -n '3,25p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0; }

while [ $# -gt 0 ]; do
  case "$1" in
    --copy)        MODE="copy" ;;
    --link)        MODE="link" ;;
    --dry-run|-n)  DRY_RUN=true ;;
    --no-fonts)    WITH_FONTS=false ;;
    --no-clean)    WITH_CLEAN=false ;;
    --yes|-y)      ASSUME_YES=true ;;
    --config-home) shift; [ $# -gt 0 ] || die "--config-home needs a directory"
                   CONFIG_HOME="$1" ;;
    -h|--help)     usage ;;
    *)             die "unknown option: $1 (use --help)" ;;
  esac
  shift
done

# Path with $HOME shortened to ~, just to keep the output readable.
short() { local tilde='~'; printf '%s' "${1/#$HOME/$tilde}"; }

# Actually runs, or just prints when --dry-run is on.
run() {
  if $DRY_RUN; then
    printf '    %s %s\n' "${DIM}would run:${RESET}" "${DIM}$*${RESET}"
  else
    "$@"
  fi
}

confirm() {
  if $ASSUME_YES || $DRY_RUN; then
    return 0
  fi
  if [ ! -t 0 ]; then
    warn "no interactive terminal — skipping (use --yes to confirm)"
    return 1
  fi
  local reply
  printf '    %s%s%s [y/N] ' "$BOLD" "$1" "$RESET"
  read -r reply
  case "$reply" in [yY]*) return 0 ;; *) return 1 ;; esac
}

# Moves whatever is at $1 to ~/.dotfiles-old/<name>-old, preserving its
# contents. Nothing gets deleted here.
stash_old() {
  local path="$1"
  local target="$OLD_DIR/$(basename "$path")-old"
  # A previous install may have already left an -old there; don't overwrite it.
  if [ -e "$target" ] || [ -L "$target" ]; then
    target="$target.$(date +%Y%m%d-%H%M%S)"
  fi
  run mkdir -p "$OLD_DIR"
  run mv "$path" "$target"
  warn "moved: $(short "$path") → $(short "$target")"
}

# install_item <path relative to the repo> <absolute destination>
install_item() {
  local src="$DOTFILES/$1" dst="$2"

  [ -e "$src" ] || die "doesn't exist in the repo: $1"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "$(short "$dst") already points to the repo"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    # A broken symlink, or one pointing elsewhere, isn't user config:
    # not worth keeping, just remove it.
    if [ -L "$dst" ]; then
      run rm "$dst"
    else
      stash_old "$dst"
    fi
  fi

  run mkdir -p "$(dirname "$dst")"
  if [ "$MODE" = "copy" ]; then
    run cp -R "$src" "$dst"
    ok "copy    $(short "$dst") ← $1"
  else
    run ln -s "$src" "$dst"
    ok "symlink $(short "$dst") → $1"
  fi
}

# Static config from older versions that no longer live at their current
# paths. Goes to ~/.dotfiles-old/ with an -old suffix, same as everything else.
stash_legacy_configs() {
  local found=false path
  for path in "$HOME/.zsh" "$HOME/.tmux.conf" "$HOME/.tmux.reset.conf" "$HOME/.vimrc"; do
    if [ -e "$path" ] && [ ! -L "$path" ]; then
      stash_old "$path"
      found=true
    fi
  done
  if ! $found; then
    skip "no legacy config left loose in \$HOME"
  fi
}

# Regenerable artifacts installed by previous configs: lazy.nvim plugins,
# mason binaries, TPM, caches, and the zsh completion dump.
# All of it comes back on its own on the new config's first boot.
clean_residuals() {
  local candidates=(
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
    "$HOME/.tmux/plugins"
    "$CONFIG_HOME/tmux/plugins"
    "$HOME/.cache/starship"
  )
  local dump
  for dump in "$HOME"/.zcompdump*; do
    if [ -e "$dump" ]; then
      candidates+=("$dump")
    fi
  done

  local targets=() path
  for path in "${candidates[@]}"; do
    if [ -e "$path" ] || [ -L "$path" ]; then
      targets+=("$path")
    fi
  done

  if [ ${#targets[@]} -eq 0 ]; then
    skip "nothing to clean"
    return
  fi

  printf '    %s\n' "${DIM}will be REMOVED (regenerable on next boot):${RESET}"
  for path in "${targets[@]}"; do
    printf '      %s %s\n' "${RED}×${RESET}" "$(short "$path") ($(du -sh "$path" 2>/dev/null | cut -f1))"
  done

  if confirm "Remove these ${#targets[@]} items?"; then
    for path in "${targets[@]}"; do
      run rm -rf "$path"
      ok "removed $(short "$path")"
    done
  else
    warn "cleanup skipped — the residuals are still there"
  fi
}

# tmux only reads its config when the server starts. Since zsh/tmux.sh uses
# `new-session -A`, a new terminal just attaches to the old server and the
# old options are still in effect — which is why the config can look like it
# "wasn't replaced".
reload_tmux() {
  if ! command -v tmux >/dev/null 2>&1; then
    skip "tmux not installed"
    return
  fi

  local version major minor
  version="$(tmux -V | sed 's/^tmux //')"
  major="${version%%.*}"
  minor="${version#*.}"
  minor="${minor//[!0-9]/}"
  # Only from 3.1 onward does tmux look at $XDG_CONFIG_HOME/tmux/tmux.conf;
  # before that the only path it reads is ~/.tmux.conf.
  if [ "$major" -lt 3 ] || { [ "$major" -eq 3 ] && [ "${minor:-0}" -lt 1 ]; }; then
    warn "tmux $version doesn't read ~/.config/tmux — linking ~/.tmux.conf too"
    install_item tmux-config/tmux/tmux.conf "$HOME/.tmux.conf"
  fi

  if ! tmux list-sessions >/dev/null 2>&1; then
    skip "no server running — the new config applies on next tmux"
    return
  fi

  run tmux source-file "$CONFIG_HOME/tmux/tmux.conf"
  ok "config reloaded in open sessions"
  warn "an option the old config set that the new one doesn't redefine is still active;"
  warn "for a fully clean state: tmux kill-server (closes all sessions)"
}

install_fonts() {
  local font_dir
  if [ "$(uname -s)" = "Darwin" ]; then
    font_dir="$HOME/Library/Fonts"
  else
    font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
  fi

  run mkdir -p "$font_dir"
  local font
  for font in "$DOTFILES"/install/fonts/*.ttf; do
    [ -e "$font" ] || { warn "no fonts in install/fonts/"; return; }
    local dst="$font_dir/$(basename "$font")"
    if [ -f "$dst" ] && cmp -s "$font" "$dst"; then
      skip "$(basename "$font") already installed"
    else
      # Font is always copied — font managers don't follow symlinks well.
      run cp "$font" "$dst"
      ok "$(basename "$font") → $(short "$font_dir")"
    fi
  done
}

configure_iterm() {
  if [ "$(uname -s)" != "Darwin" ]; then
    skip "not on macOS"
    return
  fi
  if ! command -v defaults >/dev/null 2>&1; then
    skip "defaults(1) not available"
    return
  fi

  # Global app prefs, not part of the profile JSON — iTerm2 caches these in
  # memory and flushes to disk on its own schedule, so a write while it's
  # running can be silently overwritten. Quit it first for a reliable apply.
  if pgrep -qx iTerm2; then
    warn "iTerm2 is running — quit it (Cmd-Q) and re-run for this to stick reliably"
  fi

  run defaults write com.googlecode.iterm2 SideMargin -int 14
  run defaults write com.googlecode.iterm2 TopBottomMargin -int 14
  ok "window margins set (side 14, top/bottom 14)"

  # Theme: Minimal — hides the title bar for a borderless window, closest
  # match to the reference terminals' `decorations = "None"`.
  run defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5
  ok "theme set to Minimal (borderless window)"
}

configure_macos() {
  if [ "$(uname -s)" != "Darwin" ]; then
    skip "not on macOS"
    return
  fi
  if ! command -v defaults >/dev/null 2>&1; then
    skip "defaults(1) not available"
    return
  fi

  # System-wide flat look, matching blur.enabled = false everywhere else in
  # this setup: menu bar, Dock, and Finder sidebars stop using the frosted-
  # glass vibrancy effect.
  run defaults write com.apple.universalaccess reduceTransparency -bool true
  run killall SystemUIServer 2>/dev/null || true
  run killall Dock 2>/dev/null || true
  ok "system transparency (blur) disabled"
}

check_deps() {
  local missing=() cmd
  for cmd in zsh nvim tmux starship fzf lsd; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if [ ${#missing[@]} -gt 0 ]; then
    warn "missing: ${missing[*]}"
    warn "install with: brew install ${missing[*]}"
  else
    ok "all dependencies present"
  fi

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    warn "oh-my-zsh not found at ~/.oh-my-zsh — zsh/oh-my-zsh.sh will fail"
    warn 'install with: sh -c "$(curl -fsSL https://install.ohmyz.sh)"'
  fi
}

printf '\n%sDotfiles%s  %s\n' "$BOLD" "$RESET" "$(short "$DOTFILES")"
dry_note=""
if $DRY_RUN; then
  dry_note=" | dry-run (nothing will be changed)"
fi
printf 'mode: %s%s%s | config: %s%s\n' \
  "$BOLD" "$MODE" "$RESET" "$(short "$CONFIG_HOME")" "$dry_note"

info "Configs"
install_item nvim                   "$CONFIG_HOME/nvim"
install_item tmux-config/tmux       "$CONFIG_HOME/tmux"
install_item zsh                    "$CONFIG_HOME/zsh"
install_item terminal/starship.toml "$CONFIG_HOME/starship.toml"

info "Shell"
# ~/.zshrc is just the entrypoint: it sets XDG_CONFIG_HOME and sources
# ~/.config/zsh/init.sh, which loads the rest of zsh/.
install_item zsh/zshrc "$HOME/.zshrc"

info "Legacy configs"
stash_legacy_configs

info "tmux"
reload_tmux

info "iTerm2"
configure_iterm

info "macOS"
configure_macos

if $WITH_CLEAN; then
  info "Residual cleanup"
  clean_residuals
fi

if $WITH_FONTS; then
  info "Fonts"
  install_fonts
fi

info "Dependencies"
check_deps

printf '\n%sDone.%s\n' "$GREEN$BOLD" "$RESET"
if $DRY_RUN; then
  printf 'This was a dry-run. Run without --dry-run to apply.\n\n'
else
  if [ -d "$OLD_DIR" ]; then
    printf 'Previous configs saved at %s (-old suffix).\n' "$(short "$OLD_DIR")"
  fi
  cat <<'NEXT'

Next steps:
  1. exec zsh                       — reload the shell
  2. nvim +checkhealth              — LazyVim reinstalls plugins on first boot
  3. iTerm2 → Settings → Profiles → Other Actions ▾ → Import JSON Profiles...
     and pick terminal/tokyo-compact-profile.json
  4. Select "JetBrainsMono Nerd Font" in the iTerm2 profile

NEXT
fi
