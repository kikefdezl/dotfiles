#!/bin/zsh

# .zshrc
cp .zshrc ~/
source ~/.zshrc
echo "Installed ~/.zshrc"

# .ideavimrc
cp .ideavimrc ~/
echo "Installed ~/.ideavimrc"

# .tmux.conf
cp .tmux.conf ~/
tmux source-file ~/.tmux.conf
echo "Installed ~/.tmux.conf"

# ghostty config
cp -r .config/ghostty ~/.config
echo "Installed ~/.config/ghostty/config"

