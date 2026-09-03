# Dotfiles

![wallpaper](terminal/wallpaper/tokyo-compact.png)

## Install

On a fresh machine, from scratch:

```sh
git clone https://github.com/aristotelesbr/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --dry-run   # see what it would do
./install.sh             # apply it
```

With an SSH key already set up, swap the URL for
`git@github.com:aristotelesbr/dotfiles.git`.

The clone needs to live in a permanent spot: the install creates symlinks
pointing back to it, so moving or deleting the directory breaks the shell and
nvim. `~/.dotfiles` is a safe choice — if you ever move it, just re-run
`install.sh` from the new path.

The script links each directory where the tool expects it, stashes any
previous config in `~/.dotfiles-old/` with an `-old` suffix (e.g. `nvim-old`),
and removes regenerable artifacts from older configs (lazy.nvim plugins,
mason, TPM, caches) after confirming. `./install.sh --help` lists the flags
(`--copy`, `--no-clean`, `--no-fonts`, `--yes`, `--config-home`).

| Repo | Destination |
| --- | --- |
| `nvim/` | `~/.config/nvim` |
| `tmux-config/tmux/` | `~/.config/tmux` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `zsh/` | `~/.config/zsh` |
| `zsh/zshrc` | `~/.zshrc` |
| `terminal/starship.toml` | `~/.config/starship.toml` |
| `install/fonts/` | `~/Library/Fonts` |

The iTerm2 profile (`terminal/tokyo-compact-profile.json`) is imported by
hand: Settings → Profiles → Other Actions ▾ → Import JSON Profiles...

After installing, open `nvim` and run `:checkhealth` — you'll probably need
`pip install pynvim` (Python support) and `npm i -g neovim` (Node support,
optional).
