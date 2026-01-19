#!/bin/sh

VPN_NAME="robotise"

if nmcli -t -f NAME,TYPE connection show --active \
   | grep -q "^$VPN_NAME:vpn$"; then
    echo '{"text":" VPN","class":"vpn-up"}'
else
    echo '{"text":"","class":"vpn-down"}'
fi
