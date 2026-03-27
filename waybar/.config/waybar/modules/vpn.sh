#!/bin/sh

ACTIVE_CONNECTIONS=$(nmcli -t -f NAME,TYPE connection show --active)

if echo "$ACTIVE_CONNECTIONS" | grep -iq "robotise.*"; then
    echo '{"text":" VPN","class":"robotise"}'
elif echo "$ACTIVE_CONNECTIONS" | grep -iq "Proton.*"; then
    echo '{"text":" VPN","class":"proton"}'
else
    echo '{"text":"","class":"vpn-down"}'
fi
