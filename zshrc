#!/bin/zsh
#  ______  _____   _   _        _____   _____   __   _   _____   _   _____
# |___  / /  ___/ | | | |      /  ___| /  _  \ |  \ | | |  ___| | | /  ___|
#    / /  | |___  | |_| |      | |     | | | | |   \| | | |__   | | | |
#   / /   \___  \ |  _  |      | |     | | | | | |\   | |  __|  | | | |  _
#  / /__   ___| | | | | |      | |___  | |_| | | | \  | | |     | | | |_| |
# /_____| /_____/ |_| |_|      \_____| \_____/ |_|  \_| |_|     |_| \_____/

export ZSH_DIR="${ZDOTDIR:-$HOME}/.zsh"

# Auto Updating

function {
  local cache="${ZSH_DIR}/zoppo.update"
  local epoch="$(($(date +%s) / 60 / 60 / 24))"

  if [[ ! -s "$cache" ]]; then
    print "$epoch" >!"$cache"
    return
  fi

  local last=$(<"$cache")
  print $epoch >!"$cache"

  if (( $(($epoch - $last)) > 1 )); then
    echo "Updating submodules..."
    git submodule foreach 'git pull origin master'
    clear
  fi
}

function {
  local name

  if (( $+commands[uname] )); then
    name="$(uname)"
  else
    name="Windows"
  fi

  if [[ "$name" = *Darwin* ]]; then
    function os:is-macos {
      return 0
    }

    function os:is-linux {
      return 1
    }

    function os:is-windows {
        return 1
    }
  elif [[ "$name" = *Win* ]]; then
    function os:is-macos {
      return 1
    }

    function os:is-linux {
      return 1
    }

    function os:is-windows {
      return 0
    }
  else
    function os:is-macos {
      return 1
    }

    function os:is-linux {
      return 0
    }

    function os:is-windows {
      return 1
    }
  fi
}

if os:is-linux && [[ "${TERM}" != *linux* ]]; then
  export TERM="rxvt-unicode-256color"
fi
source "$ZSH_DIR/zoppo/zoppo/zoppo.zsh" -config "$ZSH_DIR/zopporc"

autoload -Uz add-zsh-hook
setopt hist_ignore_all_dups autocd autopushd pushdignoredups correctall extended_glob prompt_subst

source "${ZSH_DIR}/variables"
source "${ZSH_DIR}/aliases"
source "${ZSH_DIR}/autostart"

update_proxy() {
  [ -f /etc/profile.d/proxy.sh ] && source /etc/profile.d/proxy.sh
}
if os:is-macos; then
  eval "restore_tty() { /bin/stty '`/bin/stty -g`' }"
else
  eval "restore_tty() { stty '`stty -g`' }"
fi

+shura-pre-cmd() {
  update_proxy
  restore_tty
}

add-zsh-hook precmd +shura-pre-cmd

[ -d "$HOME/.cargo/bin" ] && PATH="$PATH:$HOME/.cargo/bin"
export PATH
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

if [[ -d "$HOME/.wasmer" ]]; then
  export WASMER_DIR="$HOME/.wasmer"
  [ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
fi
