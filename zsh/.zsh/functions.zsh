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

# --- PORT FORWARD ---
port_forward_prod() {
    ~/scripts/port_fwd_prod.sh
}

port_forward_services() {
    ~/scripts/port_fwd_services.sh
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
vpnup() {
    nmcli connection up "robotise"
}
vpndown() {
    nmcli connection down "robotise"
}
