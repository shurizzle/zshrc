#!/bin/zsh
#  ______  _____   _   _        _____   _____   __   _   _____   _   _____
# |___  / /  ___/ | | | |      /  ___| /  _  \ |  \ | | |  ___| | | /  ___|
#    / /  | |___  | |_| |      | |     | | | | |   \| | | |__   | | | |
#   / /   \___  \ |  _  |      | |     | | | | | |\   | |  __|  | | | |  _
#  / /__   ___| | | | | |      | |___  | |_| | | | \  | | |     | | | |_| |
# /_____| /_____/ |_| |_|      \_____| \_____/ |_|  \_| |_|     |_| \_____/

if ! (( $+functions[pmodload] )); then
  fpath=(~/.zsh/completions ~/.zsh/prompts $fpath)
  export fpath
fi

autoload -U promptinit compinit
autoload -Uz add-zsh-hook
setopt hist_ignore_all_dups autocd autopushd pushdignoredups correctall extended_glob prompt_subst
promptinit
compinit

if ! (( $+functions[pmodload] )); then
  prompt borra
fi

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

export HOSTTYPE="$(uname -m)"
export INTEL_BATCH=1
export ZSH_DIR="${HOME}/.zsh"
source "${ZSH_DIR}/keys"
source "${ZSH_DIR}/variables"
for i in "${ZSH_DIR}/functions/"**/*(.); source "${i}"
for i in "${ZSH_DIR}/plugins/"**/*(.); source "${i}"
source "${ZSH_DIR}/aliases"
source "${ZSH_DIR}/autostart"

update_proxy() {
  [ -f /etc/profile.d/proxy.sh ] && source /etc/profile.d/proxy.sh
}

add-zsh-hook precmd update_proxy

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
