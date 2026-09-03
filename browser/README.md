## Chrome theme

`chrome-theme/` — a local theme extension (frame, toolbar, tabs, new-tab-page
colors) matching the Tokyo Compact palette. Chrome has no scripted way to
install this — no policy sets a local file as the New Tab background, and
unpacked extensions can't be force-loaded without an enterprise-managed
profile — so this is a one-time manual step per machine, not something
`install.sh` can do:

1. `chrome://extensions`
2. Enable **Developer mode** (top right)
3. **Load unpacked** → select `browser/chrome-theme/`

The new-tab background image can't be bundled in the theme: Chrome's classic
`theme_ntp_background` image key doesn't scale to fit the viewport (it draws
the file at native resolution, positioned by `ntp_background_alignment`), so
a full-size wallpaper just shows a zoomed-in crop. Set it by hand instead,
where Chrome does scale it properly — Customize Chrome (bottom right of a
new tab) → Background → Upload from device →
`terminal/wallpaper/tokyo-compact-browser.png`. The theme's `ntp_background`
color only shows where no image is set.
