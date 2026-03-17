#!/bin/sh

keystats_file="/var/lib/keystats/keystats.json"

# the sed makes the number comma separated, so 1234567 becomes 1,234,567
text=$(jq '.TOTAL' $keystats_file | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')

echo "{\"text\": \"$text\",\"class\":\"keystats\"}"
