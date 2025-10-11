#!/bin/zsh

HOSTNAME=$(cat /etc/hostname)
echo $HOSTNAME

# desktop
if [[ $HOSTNAME == "arch-desktop" ]]; then
  stow --target "$HOME" zsh
  stow --target "$HOME" tmux
  stow --target "$HOME" ghostty
  stow --target "$HOME" k9s
  stow --target "$HOME" hypr
  stow --target "$HOME" waybar
  stow --target "$HOME" yazi
fi

# laptop
if [[ $HOSTNAME == "kike-ThinkPad" ]]; then
  stow --target "$HOME" zsh
  stow --target "$HOME" tmux
  stow --target "$HOME" ghostty
  stow --target "$HOME" k9s
fi

# pi
if [[ $HOSTNAME == "pi" ]]; then
  stow --target "$HOME" zsh
fi
