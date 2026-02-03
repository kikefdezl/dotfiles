#!/bin/sh

keystats_file="/var/lib/keystats/keystats.json"

text=$(jq '.TOTAL' $keystats_file)

echo "{\"text\": $text,\"class\":\"keystats\"}"
