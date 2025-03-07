# TMUX configuration
if [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
  echo "TMUX is ready to go"
  echo "To start a new session, type 'tmux new-session -A -s main'"
fi
