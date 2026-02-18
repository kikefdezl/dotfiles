#!/bin/bash

function get_brightness {
    brightnessctl -m | awk -F, '{print $4}' | tr -d %
}

function send_notification {
    brightness=$(get_brightness)
    # Make the bar show the brightness percentage
    dunstify -h string:x-canonical-private-synchronous:brightness "Brightness: ${brightness}%" -h int:value:$brightness
}

case $1 in
    up)
        brightnessctl -e4 -n2 set 5%+
        send_notification
        ;;
    down)
        brightnessctl -e4 -n2 set 5%-
        send_notification
        ;;
esac
