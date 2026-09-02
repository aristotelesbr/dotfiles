## Starship Profile

Move the `starship.toml` file to `~/.config/starship.toml` to customize your Starship prompt.

## iTerm2 Profiles

- `tokyo-compact-profile.json` — dark, compact profile using JetBrainsMono Nerd Font and a Tokyo Night palette

Import via iTerm2 → Preferences → Profiles → Other Actions ▾ → Import JSON Profiles...

### Window chrome

These aren't part of the profile — iTerm2 stores them as global app preferences,
so they don't carry over on import. `install.sh` sets them automatically
(`configure_iterm`, macOS only — quit iTerm2 first, since it caches these in
memory and can overwrite the write on its next flush). To set by hand instead,
at Settings → Appearance:

- General → Theme: `Minimal` (hides the title bar, borderless window)
- Panes → Side Margins → Side margins: `14`, Top & bottom margins: `14`

Tmux config lives in `../tmux-config/tmux/`.
