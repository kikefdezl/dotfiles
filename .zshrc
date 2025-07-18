# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes for other themes
if [ $HOST = "archpi" ]; then
    ZSH_THEME="mrtazz"
else
    ZSH_THEME="kafeitu"
fi

plugins=(git)

source $ZSH/oh-my-zsh.sh

# unsets writing a folder name to auto `cd` into it
# I don't like this because it conflicts if you have a binary with 
# the same name
unsetopt autocd

# ==== aliases ====
alias k=kubectl
alias tf=terraform
alias pip="uv pip"

alias tmuxtrain="~/.tmux_sessions/train.sh"
alias tmuxdev="./.tmux.sh"

# ==== custom keymaps & bindings ==== 
bindkey '^p' up-line-or-beginning-search

# ==== load tokens ====
[ -f ~/.tokens ] && source ~/.tokens  # loads the .tokens file, which exports a few envvars with tokens

# ==== functions ====

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
# ZSH completion for cdd
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
sit(){
    curl -s -o /dev/null -X POST $HOME_ASSISTANT_URL/api/services/script/sit -H "Authorization: Bearer $HOME_ASSISTANT_BEARER_TOKEN"
    echo "OK!"
}
stand(){
    curl -s -o /dev/null -X POST $HOME_ASSISTANT_URL/api/services/script/stand -H "Authorization: Bearer $HOME_ASSISTANT_BEARER_TOKEN"
    echo "OK!"
}
