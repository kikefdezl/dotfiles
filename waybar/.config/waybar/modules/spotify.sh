#!/bin/sh

# spotify is the GUI version, spotify_player is the TUI version. Check which is playing:
player=$(playerctl -l 2>/dev/null | grep -E '^(spotify|spotify_player)$' | head -n1)
[ -z "$player" ] && exit

status=$(playerctl metadata --player="$player" --format '{{lc(status)}}')
icon=""

if [[ $status == "playing" ]]; then
  info=$(playerctl metadata --player="$player" --format '{{artist}} - {{title}}')
  if [[ ${#info} > 40 ]]; then
    info=$(echo $info | cut -c1-40)"..."
  fi
  text=$icon" "$info
elif [[ $status == "paused" ]]; then
  text=$icon
elif [[ $status == "stopped" ]]; then
  text=""
fi

echo -e "{\"text\":\""$text"\", \"class\":\""$status"\"}"
