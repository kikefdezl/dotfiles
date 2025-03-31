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

# ==== custom keymaps & bindings ==== 
bindkey '^p' up-line-or-beginning-search

# ==== load tokens ====
[ -f ~/.tokens ] && source ~/.tokens

# ==== functions ====
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

loginall() {
    # runs the loginall.sh script at ~/scripts
    ~/scripts/loginall.sh
}

HOME_ASSISTANT_URL=http://192.168.1.203:8123

sit(){
    curl -s -o /dev/null -X POST $HOME_ASSISTANT_URL/api/services/script/sit -H "Authorization: Bearer $HOME_ASSISTANT_BEARER_TOKEN"
    echo "OK!"
}

stand(){
    curl -s -o /dev/null -X POST $HOME_ASSISTANT_URL/api/services/script/stand -H "Authorization: Bearer $HOME_ASSISTANT_BEARER_TOKEN"
    echo "OK!"
}

