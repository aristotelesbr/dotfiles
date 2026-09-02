#!/usr/bin/env bash
#
# Dotfiles installer
#
# Coloca cada parte deste repo onde a ferramenta correspondente procura por ela.
# Por padrão cria symlinks, então editar um arquivo no repo já vale na hora e o
# `git status` continua enxergando suas mudanças. Use --copy para cópias soltas.
#
# Configuração estática que já existir no destino não é apagada: ela é movida
# para ~/.dotfiles-old/ com o sufixo -old (ex.: nvim -> ~/.dotfiles-old/nvim-old).
# Já os artefatos regeneráveis das configs antigas (plugins do lazy.nvim, mason,
# TPM, caches, zcompdump) são removidos na fase de limpeza, com confirmação.
#
#   ./install.sh                 # instala tudo (configs, shell, fontes, limpeza)
#   ./install.sh --dry-run       # mostra o que faria, sem alterar nada
#   ./install.sh --copy          # copia em vez de linkar
#   ./install.sh --no-fonts      # pula a instalação das fontes
#   ./install.sh --no-clean      # pula a limpeza de resíduos
#   ./install.sh --yes           # não pergunta nada (para automação)
#   ./install.sh --config-home D # usa D no lugar de ~/.config

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
    --config-home) shift; [ $# -gt 0 ] || die "--config-home precisa de um diretório"
                   CONFIG_HOME="$1" ;;
    -h|--help)     usage ;;
    *)             die "opção desconhecida: $1 (use --help)" ;;
  esac
  shift
done

# Caminho com $HOME abreviado para ~, só para deixar a saída legível.
short() { local tilde='~'; printf '%s' "${1/#$HOME/$tilde}"; }

# Executa de verdade, ou só imprime quando --dry-run está ligado.
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
    warn "sem terminal interativo — pulando (use --yes para confirmar)"
    return 1
  fi
  local reply
  printf '    %s%s%s [y/N] ' "$BOLD" "$1" "$RESET"
  read -r reply
  case "$reply" in [yY]*) return 0 ;; *) return 1 ;; esac
}

# Move o que estiver em $1 para ~/.dotfiles-old/<nome>-old, preservando o
# conteúdo. Nada é apagado aqui.
stash_old() {
  local path="$1"
  local target="$OLD_DIR/$(basename "$path")-old"
  # Instalações anteriores podem já ter deixado um -old ali; não sobrescreve.
  if [ -e "$target" ] || [ -L "$target" ]; then
    target="$target.$(date +%Y%m%d-%H%M%S)"
  fi
  run mkdir -p "$OLD_DIR"
  run mv "$path" "$target"
  warn "movido: $(short "$path") → $(short "$target")"
}

# install_item <caminho relativo ao repo> <destino absoluto>
install_item() {
  local src="$DOTFILES/$1" dst="$2"

  [ -e "$src" ] || die "não existe no repo: $1"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "$(short "$dst") já aponta pro repo"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    # Symlink quebrado ou apontando para outro lugar não é config do usuário:
    # não vale a pena guardar, só remove.
    if [ -L "$dst" ]; then
      run rm "$dst"
    else
      stash_old "$dst"
    fi
  fi

  run mkdir -p "$(dirname "$dst")"
  if [ "$MODE" = "copy" ]; then
    run cp -R "$src" "$dst"
    ok "cópia   $(short "$dst") ← $1"
  else
    run ln -s "$src" "$dst"
    ok "symlink $(short "$dst") → $1"
  fi
}

# Configs estáticas de versões antigas que não moram mais nos caminhos atuais.
# Vão para ~/.dotfiles-old/ com sufixo -old, igual ao resto.
stash_legacy_configs() {
  local found=false path
  for path in "$HOME/.zsh" "$HOME/.tmux.conf" "$HOME/.tmux.reset.conf" "$HOME/.vimrc"; do
    if [ -e "$path" ] && [ ! -L "$path" ]; then
      stash_old "$path"
      found=true
    fi
  done
  if ! $found; then
    skip "nenhuma config legada solta no \$HOME"
  fi
}

# Artefatos regeneráveis instalados pelas configs anteriores: plugins do
# lazy.nvim, binários do mason, TPM, caches e o dump de completions do zsh.
# Tudo isso volta sozinho no primeiro boot da config nova.
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
    skip "nada a limpar"
    return
  fi

  printf '    %s\n' "${DIM}serão REMOVIDOS (regeneráveis no próximo boot):${RESET}"
  for path in "${targets[@]}"; do
    printf '      %s %s\n' "${RED}×${RESET}" "$(short "$path") ($(du -sh "$path" 2>/dev/null | cut -f1))"
  done

  if confirm "Remover esses ${#targets[@]} itens?"; then
    for path in "${targets[@]}"; do
      run rm -rf "$path"
      ok "removido $(short "$path")"
    done
  else
    warn "limpeza pulada — os resíduos continuam no lugar"
  fi
}

# tmux lê a config só quando o servidor sobe. Como o zsh/tmux.sh usa
# `new-session -A`, terminal novo apenas anexa no servidor velho e as opções
# antigas continuam valendo — daí a config parecer que "não foi substituída".
reload_tmux() {
  if ! command -v tmux >/dev/null 2>&1; then
    skip "tmux não instalado"
    return
  fi

  local version major minor
  version="$(tmux -V | sed 's/^tmux //')"
  major="${version%%.*}"
  minor="${version#*.}"
  minor="${minor//[!0-9]/}"
  # Só a partir da 3.1 o tmux procura em $XDG_CONFIG_HOME/tmux/tmux.conf;
  # antes disso o único caminho lido é ~/.tmux.conf.
  if [ "$major" -lt 3 ] || { [ "$major" -eq 3 ] && [ "${minor:-0}" -lt 1 ]; }; then
    warn "tmux $version não lê ~/.config/tmux — linkando ~/.tmux.conf também"
    install_item tmux-config/tmux/tmux.conf "$HOME/.tmux.conf"
  fi

  if ! tmux list-sessions >/dev/null 2>&1; then
    skip "nenhum servidor rodando — a config nova vale no próximo tmux"
    return
  fi

  run tmux source-file "$CONFIG_HOME/tmux/tmux.conf"
  ok "config recarregada nas sessões abertas"
  warn "opção que a config antiga setou e a nova não redefine continua ativa;"
  warn "para estado 100% limpo: tmux kill-server (fecha todas as sessões)"
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
    [ -e "$font" ] || { warn "nenhuma fonte em install/fonts/"; return; }
    local dst="$font_dir/$(basename "$font")"
    if [ -f "$dst" ] && cmp -s "$font" "$dst"; then
      skip "$(basename "$font") já instalada"
    else
      # Fonte é sempre copiada — gerenciador de fontes não segue symlink direito.
      run cp "$font" "$dst"
      ok "$(basename "$font") → $(short "$font_dir")"
    fi
  done
}

check_deps() {
  local missing=() cmd
  for cmd in zsh nvim tmux starship fzf lsd; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if [ ${#missing[@]} -gt 0 ]; then
    warn "faltando: ${missing[*]}"
    warn "instale com: brew install ${missing[*]}"
  else
    ok "todas as dependências presentes"
  fi

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    warn "oh-my-zsh não encontrado em ~/.oh-my-zsh — zsh/oh-my-zsh.sh vai falhar"
    warn 'instale com: sh -c "$(curl -fsSL https://install.ohmyz.sh)"'
  fi
}

printf '\n%sDotfiles%s  %s\n' "$BOLD" "$RESET" "$(short "$DOTFILES")"
dry_note=""
if $DRY_RUN; then
  dry_note=" | dry-run (nada será alterado)"
fi
printf 'modo: %s%s%s | config: %s%s\n' \
  "$BOLD" "$MODE" "$RESET" "$(short "$CONFIG_HOME")" "$dry_note"

info "Configs"
install_item nvim                   "$CONFIG_HOME/nvim"
install_item tmux-config/tmux       "$CONFIG_HOME/tmux"
install_item zsh                    "$CONFIG_HOME/zsh"
install_item terminal/starship.toml "$CONFIG_HOME/starship.toml"

info "Shell"
# ~/.zshrc é só o entrypoint: define XDG_CONFIG_HOME e dá source no
# ~/.config/zsh/init.sh, que carrega o resto do zsh/.
install_item zsh/zshrc "$HOME/.zshrc"

info "Configs legadas"
stash_legacy_configs

info "tmux"
reload_tmux

if $WITH_CLEAN; then
  info "Limpeza de resíduos"
  clean_residuals
fi

if $WITH_FONTS; then
  info "Fontes"
  install_fonts
fi

info "Dependências"
check_deps

printf '\n%sPronto.%s\n' "$GREEN$BOLD" "$RESET"
if $DRY_RUN; then
  printf 'Isso foi um dry-run. Rode sem --dry-run pra aplicar.\n\n'
else
  if [ -d "$OLD_DIR" ]; then
    printf 'Configs anteriores guardadas em %s (sufixo -old).\n' "$(short "$OLD_DIR")"
  fi
  cat <<'NEXT'

Próximos passos:
  1. exec zsh                       — recarrega o shell
  2. nvim +checkhealth              — LazyVim reinstala os plugins no 1º boot
  3. iTerm2 → Settings → Profiles → Other Actions ▾ → Import JSON Profiles...
     e escolha terminal/tokyo-compact-profile.json
  4. Selecione "JetBrainsMono Nerd Font" no perfil do iTerm2

NEXT
fi
