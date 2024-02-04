#!/bin/zsh

# .zshrc
cp .zshrc ~/
source ~/.zshrc
echo "Installed ~/.zshrc"

# neovim
sudo rm -rf ~/.config/nvim
sudo rm -rf ~/.local/share/nvim
sudo rm -rf ~/.cache/nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 
sudo rm -rf ~/.config/nvim/lua/custom
git clone git@github.com:kikefdezl/neovim-kikefdezl.git ~/.config/nvim/lua/custom --depth 1
echo "Installed ~/.config/nvim/"

# .ideavimrc
cp .ideavimrc ~/
echo "Installed ~/.ideavimrc"

