#!/bin/zsh
#  ______  _____   _   _        _____   _____   __   _   _____   _   _____
# |___  / /  ___/ | | | |      /  ___| /  _  \ |  \ | | |  ___| | | /  ___|
#    / /  | |___  | |_| |      | |     | | | | |   \| | | |__   | | | |
#   / /   \___  \ |  _  |      | |     | | | | | |\   | |  __|  | | | |  _
#  / /__   ___| | | | | |      | |___  | |_| | | | \  | | |     | | | |_| |
# /_____| /_____/ |_| |_|      \_____| \_____/ |_|  \_| |_|     |_| \_____/

#fpath=(~/.zsh/completions ~/.zsh/prompts $fpath)
#export fpath

autoload -U promptinit compinit
setopt hist_ignore_all_dups autocd autopushd pushdignoredups correctall extended_glob prompt_subst
promptinit
compinit

preexec() { which pre_exec &>/dev/null && pre_exec }
precmd() { which pre_cmd &>/dev/null && pre_cmd }

#prompt borra

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSpiacente, nessun risultato per: %d%b'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:kill:*' command 'ps -au$UID -o pid,command'

if [[ "${TERM}" == *screen* ]]; then
  export TERM="screen-256color"
elif [[ "${TERM}" == *xterm* || "${TERM}" == *rxvt* ]]; then
  export TERM="xterm-256color"
fi

is_cmd() { command which "${1}" &>/dev/null || return 1 }

export HOSTTYPE="$(uname -m)"
export INTEL_BATCH=1
export ZSH_DIR="${HOME}/.zsh"
source "${ZSH_DIR}/keys"
source "${ZSH_DIR}/variables"
for i in "${ZSH_DIR}/functions/"**/*(.); source "${i}"
for i in "${ZSH_DIR}/plugins/"**/*(.); source "${i}"
source "${ZSH_DIR}/aliases"
source "${ZSH_DIR}/autostart"

pre_exec() {
  source /etc/profile.d/proxy.sh
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
