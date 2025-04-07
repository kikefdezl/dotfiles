#!/bin/zsh

# .zshrc
cp .zshrc ~/
source ~/.zshrc
echo "Installed ~/.zshrc"

# .ideavimrc
cp .ideavimrc ~/
echo "Installed ~/.ideavimrc"

# tmux
cp .tmux.conf ~/
tmux source-file ~/.tmux.conf
echo "Installed ~/.tmux.conf"
cp -r .tmux_sessions ~/
echo "Installed ~/.tmux_sessions/"

# ghostty config
cp -r .config/ghostty ~/.config
echo "Installed ~/.config/ghostty/config"

