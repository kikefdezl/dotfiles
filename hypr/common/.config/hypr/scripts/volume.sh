#!/bin/bash

function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

function is_mute {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED
}

function send_volume_notification {
    volume=$(get_volume)
    dunstify -h string:x-canonical-private-synchronous:audio "Volume - $volume%" -h int:value:$volume
}

function send_mute_notification {
    dunstify -h string:x-canonical-private-synchronous:audio "Muted" ""
}

if is_mute; then 
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    send_volume_notification
else
    case $1 in
        up)
            wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+
            send_volume_notification
            ;;
        down)
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
            send_volume_notification
            ;;
        mute)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            send_mute_notification
            ;;
    esac
fi
