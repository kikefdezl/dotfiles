# --- VENV ---
venv() {
    # use `venv` to activate a venv in the CWD

    # Check if already activated
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        echo -e "\n\e[1;33mDeactivating current virtual environment...\e[0m"
        deactivate
        return
    fi

    # Check if the venv directory exists
    if [ -d ".venv" ]; then
        echo -e "\n\e[1;33mActivating virtual environment...\e[0m"
        source .venv/bin/activate
    else
        echo -e "\n\e[1;33mCreating and activating virtual environment...\e[0m"
        uv venv 
        source .venv/bin/activate
    fi
}

# --- CDD ---
# cdd <repo>: change to ~/Dev/<repo>
# Allows me to change directory to one of my repos in ~/Dev from any path. Supports tab to autocomplete
DEV_DIR="$HOME/Dev"
cdd() {
  if [[ -z "$1" ]]; then
    cd -- "$DEV_DIR"
  else
    local matches=()
    # Case-sensitive substring matching on directory names
    for dir in "$DEV_DIR"/*(N/); do
      [[ ${dir:t} == *"$1"* ]] && matches+=("$dir")
    done

    case ${#matches[@]} in
      0) echo "No repo matching '*$1*' in $DEV_DIR" >&2; return 1 ;;
      1) cd -- "${matches[1]}" ;;
      *) 
        echo "Multiple matches:" >&2
        printf '  %s\n' "${matches[@]##*/}" >&2
        return 1
        ;;
    esac
  fi
}
# ZSH tab-completion
_cdd() {
  local -a repos
  # Get all directories under DEV_DIR
  repos=("$DEV_DIR"/*(N/:t))
  # Generate completion matches
  _describe 'repo' repos
}
compdef _cdd cdd

# --- SIT/STAND ---
HOME_ASSISTANT_URL=http://192.168.1.203:8123
sit() {
    if output=$(curl -sSf -X POST "$HOME_ASSISTANT_URL/api/services/script/sit" \
        -H "Authorization: Bearer $HOME_ASSISTANT_BEARER_TOKEN" 2>&1); then
        echo "OK!"
    else
        echo "Failed: $output"
    fi
}
stand(){
    if output=$(curl -sSf -X POST "$HOME_ASSISTANT_URL/api/services/script/stand" \
        -H "Authorization: Bearer $HOME_ASSISTANT_BEARER_TOKEN" 2>&1); then
        echo "OK!"
    else
        echo "Failed: $output"
    fi
}

# --- HEADPHONES / SPEAKERS ---
change_to_audio_device() {
    local device_name="$1"
    local sink_id=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep -i "$device_name" | grep -oP '\d+' | head -1)

    if [ -z "$sink_id" ]; then
        echo "Error: Sink matching '$device_name' not found"
        return 1
    fi

    wpctl set-default "$sink_id"
    echo "Switched to $device_name (ID: $sink_id)"
}
headphones() {
    change_to_audio_device "hyperx"
}
speakers() {
    change_to_audio_device "pcm2704"
}

# --- VPN ---
vpn() {
    case "$1" in
        up)
            nmcli connection up "robotise"
            ;;
        down)
            nmcli connection down "robotise"
            ;;
        *)
            echo "Error: Invalid argument. Usage: vpn [up|down]"
            return 1
            ;;
    esac
}

# --- BLUETOOTH & HEADPHONES ---
bluetooth() {
    local mode=${1:-status}
    
    case $mode in
        on|start|up)
            sudo systemctl start bluetooth
            echo "Bluetooth daemon started"
            ;;
        off|stop|down)
            sudo systemctl stop bluetooth
            echo "Bluetooth daemon stopped"
            ;;
        status)
            systemctl is-active bluetooth && echo "Bluetooth: running" || echo "Bluetooth: stopped"
            ;;
        *)
            echo "Usage: bluetooth [on|off|status]"
            ;;
    esac
}

export MOMENTUM_BT_MAC="80:C3:BA:3F:83:9F"

# TODO: Go back to CLI when they fix the bug:
# https://github.com/bluez/bluez/issues/1896
# For now, forcing interactive mode with the alternative below
#
# momentum() {
#     local mode=$1
#     
#     case $mode in
#         on)
#             if ! bluetoothctl info $MOMENTUM_BT_MAC | grep -q "Connected: yes"; then
#                 bluetoothctl connect $MOMENTUM_BT_MAC
#                 sleep 1
#             fi
#             if bluetoothctl info $MOMENTUM_BT_MAC | grep -q "Connected: yes"; then
#                 echo "Connected: MOMENTUM 4"
#             else
#                 echo "Failed to connect to MOMENTUM 4" >&2
#                 return 1
#             fi
#             ;;
#         off)
#             if bluetoothctl info $MOMENTUM_BT_MAC | grep -q "Connected: yes"; then
#                 bluetoothctl disconnect $MOMENTUM_BT_MAC
#             fi
#             if ! bluetoothctl info $MOMENTUM_BT_MAC | grep -q "Connected: yes"; then
#                 echo "Disconnected: MOMENTUM 4"
#             else
#                 echo "Failed to disconnect" >&2
#                 return 1
#             fi
#             ;;
#         *)
#             echo "Usage: momentum [on|off]"
#             echo "  on (default) - Connect to MOMENTUM 4"
#             echo "  off          - Disconnect MOMENTUM 4"
#             ;;
#     esac
# }

momentum() {
    local mode=$1

    bt_info() {
        echo "info $MOMENTUM_BT_MAC" | bluetoothctl
    }

    case $mode in
        on)
            if ! bt_info | grep -q "Connected: yes"; then
                bluetoothctl connect $MOMENTUM_BT_MAC
                sleep 1
            fi
            if bt_info | grep -q "Connected: yes"; then
                echo "Connected: MOMENTUM 4"
            else
                echo "Failed to connect to MOMENTUM 4" >&2
                return 1
            fi
            ;;
        off)
            if bt_info | grep -q "Connected: yes"; then
                bluetoothctl disconnect $MOMENTUM_BT_MAC
            fi
            if ! bt_info | grep -q "Connected: yes"; then
                echo "Disconnected: MOMENTUM 4"
            else
                echo "Failed to disconnect" >&2
                return 1
            fi
            ;;
        *)
            echo "Usage: momentum [on|off]"
            echo "  on  - Connect to MOMENTUM 4"
            echo "  off - Disconnect MOMENTUM 4"
            ;;
    esac
}

fwd() {
  case "$1" in
    dev)
      ~/scripts/port-fwd-dev.sh
      ;;
    prod)
      echo "Prod port forwarding is not yet implemented."
      ;;
    *)
      echo "Usage: fwd <dev|prod>"
      return 1
      ;;
  esac
}
