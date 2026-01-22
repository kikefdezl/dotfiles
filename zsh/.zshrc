# ==== oh my zsh ==== 
export ZSH="$HOME/.oh-my-zsh"

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes for other themes
if [ $HOST = "pi" ]; then
    ZSH_THEME="mrtazz"
else
    ZSH_THEME="kafeitu"
fi

plugins=( git z )

source $ZSH/oh-my-zsh.sh

# ==== PATH ====
export PATH="$HOME/.cargo/bin:$PATH"

# ==== options ====

unsetopt autocd # unsets writing a folder name to auto `cd` into it. I don't like this because it conflicts if you have a binary with the same name

bindkey '^p' up-line-or-beginning-search

# ==== aliases ==== 
source ~/.zsh/aliases.zsh

# ==== envvars ====
export EDITOR="nvim"

# ==== tokens ====
[ -f ~/.tokens ] && source ~/.tokens  # loads the .tokens file, which exports envvars with sensitive tokens

# ==== functions ====
source ~/.zsh/functions.zsh

# ==== gcloud ====
__remove_gke(){ rm -f "$HOME/.kube/gke_gcloud_auth_plugin_cache" }
gdev(){ __remove_gke && gcloud config configurations activate terraform-dev }
gdevops(){ __remove_gke && gcloud config configurations activate kike-devops }
gai(){ __remove_gke && gcloud config configurations activate tooling-ai }
