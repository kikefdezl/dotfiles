#!/bin/bash

function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

function is_mute {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED
}

function send_notification {
    volume=$(get_volume)
    # Make the bar with the special character ─
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i audio-volume-high -t 1000 -r 2593 -u normal "Volume: $volume%" "$bar"
}

case $1 in
    up)
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+
        send_notification
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
        send_notification
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        if is_mute ; then
            dunstify -i audio-volume-muted -t 1000 -r 2593 -u normal "Muted" ""
        else
            send_notification
        fi
        ;;
esac
