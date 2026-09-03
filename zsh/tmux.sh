# O shell abre limpo: com tmux e herdr instalados, um sempre acabaria abrindo
# dentro do outro. Escolha na hora — `tmux a` ou `herdr`.
# Pra voltar a cair no tmux sozinho como antes, exporte AUTO_TMUX=1.
if [ -z "$TMUX" ] && [ -n "$AUTO_TMUX" ]; then
  exec tmux new-session -A -s "${TMUX_SESSION:-main}"
fi
