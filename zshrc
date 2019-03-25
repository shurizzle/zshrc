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

if [[ "${TERM}" != *linux* && "$(uname)" != *Darwin* ]]; then
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
if [[ "$(uname)" != *Darwin* ]]; then
    eval "restore_tty() { stty '`stty -g`' }"
else
    eval "restore_tty() { /bin/stty '`/bin/stty -g`' }"
fi

+shura-pre-cmd() {
    update_proxy
    restore_tty
}

add-zsh-hook precmd +shura-pre-cmd

alias boot-usb='qemu-system-i386 -enable-kvm -vga qxl -usb -usbdevice host:03f0:5607 -net nic,model=virtio -net user -m 1024'

is-command rbenv && eval "$(rbenv init -)"

[ -d "$HOME/.cargo/bin" ] && PATH="$PATH:$HOME/.cargo/bin"
export PATH
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

if [[ -d "$HOME/.wasmer" ]]; then
    export WASMER_DIR="$HOME/.wasmer"
    [ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
fi
