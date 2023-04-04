#!/bin/zsh
#  ______  _____   _   _        _____   _____   __   _   _____   _   _____
# |___  / /  ___/ | | | |      /  ___| /  _  \ |  \ | | |  ___| | | /  ___|
#    / /  | |___  | |_| |      | |     | | | | |   \| | | |__   | | | |
#   / /   \___  \ |  _  |      | |     | | | | | |\   | |  __|  | | | |  _
#  / /__   ___| | | | | |      | |___  | |_| | | | \  | | |     | | | |_| |
# /_____| /_____/ |_| |_|      \_____| \_____/ |_|  \_| |_|     |_| \_____/

export ZSH_DIR="${${(%):-%x}:a:P:h}"

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

    function os:linux:is-wsl2 {
      return 1
    }

    function os:is-bsd {
      return 0
    }

    function os:is-freebsd {
      return 1
    }

    function os:is-dragonflybsd {
      return 1
    }

    function os:is-netbsd {
      return 1
    }

    function os:is-openbsd {
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

    function os:linux:is-wsl2 {
      return 1
    }

    function os:is-bsd {
      return 1
    }

    function os:is-freebsd {
      return 1
    }

    function os:is-dragonflybsd {
      return 1
    }

    function os:is-netbsd {
      return 1
    }

    function os:is-openbsd {
      return 1
    }
  elif [[ "$name" = *Linux* ]]; then
    function os:is-macos {
      return 1
    }

    function os:is-linux {
      return 0
    }

    function os:is-windows {
      return 1
    }

    if [[ "$(< /proc/sys/kernel/osrelease)" = *[Mm]icrosoft* ]]; then
      function os:linux:is-wsl2 {
        return 0
      }
    else
      function os:linux:is-wsl2 {
        return 1
      }
    fi

    function os:is-bsd {
      return 1
    }

    function os:is-freebsd {
      return 1
    }

    function os:is-dragonflybsd {
      return 1
    }

    function os:is-netbsd {
      return 1
    }

    function os:is-openbsd {
      return 1
    }
  elif [[ "$name" = FreeBSD ]]; then
    function os:is-macos {
      return 1
    }

    function os:is-linux {
      return 1
    }

    function os:is-windows {
      return 1
    }

    function os:linux:is-wsl2 {
      return 1
    }

    function os:is-bsd {
      return 0
    }

    function os:is-freebsd {
      return 0
    }

    function os:is-dragonflybsd {
      return 1
    }

    function os:is-netbsd {
      return 1
    }

    function os:is-openbsd {
      return 1
    }
  elif [[ "$name" = DragonFly ]]; then
    function os:is-macos {
      return 1
    }

    function os:is-linux {
      return 1
    }

    function os:is-windows {
      return 1
    }

    function os:linux:is-wsl2 {
      return 1
    }

    function os:is-bsd {
      return 0
    }

    function os:is-freebsd {
      return 1
    }

    function os:is-dragonflybsd {
      return 0
    }

    function os:is-netbsd {
      return 1
    }

    function os:is-openbsd {
      return 1
    }
  elif [[ "$name" = NetBSD ]]; then
    function os:is-macos {
      return 1
    }

    function os:is-linux {
      return 1
    }

    function os:is-windows {
      return 1
    }

    function os:linux:is-wsl2 {
      return 1
    }

    function os:is-bsd {
      return 0
    }

    function os:is-freebsd {
      return 1
    }

    function os:is-dragonflybsd {
      return 1
    }

    function os:is-netbsd {
      return 0
    }

    function os:is-openbsd {
      return 1
    }
  elif [[ "$name" = OpenBSD ]]; then
    function os:is-macos {
      return 1
    }

    function os:is-linux {
      return 1
    }

    function os:is-windows {
      return 1
    }

    function os:linux:is-wsl2 {
      return 1
    }

    function os:is-bsd {
      return 0
    }

    function os:is-freebsd {
      return 1
    }

    function os:is-dragonflybsd {
      return 1
    }

    function os:is-netbsd {
      return 1
    }

    function os:is-openbsd {
      return 0
    }
  fi
}

if os:is-netbsd; then
  PATH="/usr/pkg/sbin:/usr/pkg/bin:/sbin:/usr/sbin:/bin:/usr/bin"
  if [[ "$TERM" = xterm-kitty ]]; then
    TERM="xterm-256color"
    export TERM
  fi
elif os:is-bsd; then
  PATH="/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin:${HOME}/bin"
else
  [ -d /bin ] && PATH="/bin${PATH:+:$PATH}"
  [ -d /usr/sbin ] && PATH="/usr/sbin${PATH:+:$PATH}"
  [ -d /sbin ] && PATH="/sbin${PATH:+:$PATH}"
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
eval "restore_tty() { stty '`stty -g`' }"

+shura-pre-cmd() {
  update_proxy
  restore_tty
}

add-zsh-hook precmd +shura-pre-cmd
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

[ -d "$HOME/.cargo/bin" ] && PATH="${PATH:+$PATH:}$HOME/.cargo/bin"
export PATH
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

if [[ -n $KITTY_INSTALLATION_DIR ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

if is-command cloud_sql_proxy; then
  cloud_sql_proxy() {
    mkdir -p ~/.local/sockets/cloud_sql_proxy
    command cloud_sql_proxy -dir ~/.local/sockets/cloud_sql_proxy "$@"
  }
fi

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
else
  if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  fi

  if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

if [[ "$TERM" = "xterm-kitty" ]] && os:is-macos; then
  export TERMINFO="/Applications/kitty.app/Contents/Resources/kitty/terminfo"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if is-command yay; then
  alias pacautoremove='yay -Ycc'
elif is-command pacman; then
  alias pacautoremove='sudo pacman -Rcns $(pacman -Qdtq)'
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
