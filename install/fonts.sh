#!/bin/bash

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit 1

echo "Downloading CascadiaMono Nerd Font..."
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaFont
mkdir -p ~/Library/Fonts
cp CascadiaFont/*.ttf ~/Library/Fonts
rm -rf CascadiaMono.zip CascadiaFont

echo "Downloading iA Writer Mono Font..."
curl -L -o iafonts.zip https://github.com/iaolo/iA-Fonts/archive/refs/heads/master.zip
unzip iafonts.zip -d iaFonts
cp iaFonts/iA-Fonts-master/iA\ Writer\ Mono/Static/iAWriterMonoS-*.ttf ~/Library/Fonts
rm -rf iafonts.zip iaFonts

cd ~
rm -rf "$TMP_DIR"

echo "Fonts installed successfully! If they don't appear immediately, try restarting your applications."
