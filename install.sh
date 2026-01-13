#!/bin/zsh

HOSTNAME=$(cat /etc/hostname)
echo $HOSTNAME

# desktop
if [[ $HOSTNAME == "arch-desktop" ]]; then
  stow --target "$HOME" dunst
  stow --target "$HOME" tmux
  stow --target "$HOME" ghostty
  stow --target "$HOME" k9s
  stow --target "$HOME" -d hypr common desktop
  stow --target "$HOME" mltop
  stow --target "$HOME" waybar
  stow --target "$HOME" wofi
  stow --target "$HOME" yazi
  stow --target "$HOME" zsh
fi

# thinkpad
if [[ $HOSTNAME == "kike-ThinkPad" ]]; then
  stow --target "$HOME" zsh
  stow --target "$HOME" tmux
  stow --target "$HOME" mltop
  stow --target "$HOME" ghostty
  stow --target "$HOME" k9s
fi

# pi
if [[ $HOSTNAME == "pi" ]]; then
  stow --target "$HOME" zsh
  stow --target "$HOME" mltop
fi

# acer laptop
if [[ $HOSTNAME == "archcer" ]]; then
  stow --target "$HOME" zsh
  stow --target "$HOME" ghostty
  stow --target "$HOME" tmux
  stow --target "$HOME" hypr
  stow --target "$HOME" waybar
  stow --target "$HOME" wofi
  stow --target "$HOME" yazi
  stow --target "$HOME" mltop
fi

# thinkpad-t14s
if [[ $HOSTNAME == "kike-thinkpad-t14s" ]]; then
  stow --target "$HOME" dunst
  stow --target "$HOME" ghostty
  stow --target "$HOME" tmux
  stow --target "$HOME" -d hypr common laptop
  stow --target "$HOME" waybar
  stow --target "$HOME" wofi
  stow --target "$HOME" mltop
  stow --target "$HOME" k9s
  stow --target "$HOME" yazi
  stow --target "$HOME" zsh
fi
