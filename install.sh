#!/bin/zsh

# desktop
if [[ "$(hostname)" == "arch-desktop" ]]; then
  stow --target "$HOME" zsh
  stow --target "$HOME" ideavim
  stow --target "$HOME" tmux
  stow --target "$HOME" ghostty
  stow --target "$HOME" k9s
  stow --target "$HOME" zellij
  stow --target "$HOME" hypr
  stow --target "$HOME" waybar
fi

# laptop
if [[ "$(hostname)" == "kike-ThinkPad" ]]; then
  stow --target "$HOME" zsh
  stow --target "$HOME" ghostty
  stow --target "$HOME" k9s
fi
