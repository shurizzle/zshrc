#!/bin/zsh
#  ______  _____   _   _        _____   _____   __   _   _____   _   _____
# |___  / /  ___/ | | | |      /  ___| /  _  \ |  \ | | |  ___| | | /  ___|
#    / /  | |___  | |_| |      | |     | | | | |   \| | | |__   | | | |
#   / /   \___  \ |  _  |      | |     | | | | | |\   | |  __|  | | | |  _
#  / /__   ___| | | | | |      | |___  | |_| | | | \  | | |     | | | |_| |
# /_____| /_____/ |_| |_|      \_____| \_____/ |_|  \_| |_|     |_| \_____/

if (( $+TERMUX_APP_PID )) && (( $+commands[termux-chroot] )); then
    if ! (( $+TERMUX_CHROOTED )); then
        export TERMUX_CHROOTED=0
        exec termux-chroot
    elif [ "$TERMUX_CHROOTED" = 0 ]; then
        export TERMUX_CHROOTED=1
        if [ "${PWD:r}" = "${PREFIX:h:r}/home" ]; then
            cd ~
        fi
    fi
fi

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

    local windows=1
    local macos=1
    local linux=1
    local wsl2=1
    local termux=1
    local bsd=1
    local freebsd=1
    local dragonflybsd=1
    local netbsd=1
    local openbsd=1

    if [[ "$name" = *Darwin* ]]; then
        bsd=0
        macos=0
    elif [[ "$name" = *Win* ]]; then
        windows=0
    elif [[ "$name" = *Linux* ]]; then
        linux=0
        if [ -n "${TERMUX_APP_PID-}" ]; then
            termux=0
        elif [[ "$(< /proc/sys/kernel/osrelease)" = *[Mm]icrosoft* ]]; then
            wsl2=0
        fi
    elif [[ "$name" = FreeBSD ]]; then
        bsd=0
        freebsd=0
    elif [[ "$name" = DragonFly ]]; then
        bsd=0
        dragonflybsd=0
    elif [[ "$name" = NetBSD ]]; then
        bsd=0
        netbsd=0
    elif [[ "$name" = OpenBSD ]]; then
        bsd=0
        openbsd=0
    fi

    local n
    typeset -g functions

    for n in 'windows' 'macos' 'linux' 'bsd' 'freebsd' 'dragonflybsd' 'netbsd' \
        'openbsd'; do
        functions[os:is-${n}]="return ${(P)n}"
    done
    functions[os:linux:is-wsl2]="return ${wsl2}"
    functions[os:linux:is-termux]="return ${termux}"
}

if os:is-netbsd; then
    PATH="/usr/pkg/sbin:/usr/pkg/bin:/sbin:/usr/sbin:/bin:/usr/bin"
elif os:is-bsd; then
    PATH="/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin:${HOME}/bin"
else
    [ -d /bin ] && PATH="/bin${PATH:+:$PATH}"
    [ -d /usr/sbin ] && PATH="/usr/sbin${PATH:+:$PATH}"
    [ -d /sbin ] && PATH="/sbin${PATH:+:$PATH}"
fi

source "$ZSH_DIR/zoppo/zoppo/zoppo.zsh" -config "$ZSH_DIR/zopporc"
prompt_pure_colors[yazi]="${prompt_pure_colors[virtualenv]}"
PROMPT='%(13V.%F{$prompt_pure_colors[yazi]}%13v%f .)'"$PROMPT"
PROMPT2='%F{242}…%F{reset} '

autoload -Uz add-zsh-hook
setopt hist_ignore_all_dups autocd autopushd pushdignoredups correctall extended_glob prompt_subst

source "${ZSH_DIR}/variables"
source "${ZSH_DIR}/aliases"
source "${ZSH_DIR}/autostart"

eval "restore_tty() { stty '`stty -g`' }"

+pure-yazi() {
    psvar[13]=
    if [ -n "$YAZI_LEVEL" ]; then
        if (( YAZI_LEVEL > 1 )); then
            psvar[13]="$YAZI_LEVEL"$'\uef81 '
        else
            psvar[13]=$'\uef81 '
        fi
    fi
}
add-zsh-hook precmd +pure-yazi

__shura_prompt_executing=""
function +shura-pre-cmd() {
    local ret="$?"
    restore_tty
    printf '\033[?25h\033[6 q'
    if test "$__shura_prompt_executing" != "0"; then
        _PROMPT_SAVE_PS1="$PS1"
        _PROMPT_SAVE_PS2="$PS2"
        PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
        PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi
    if test "$__shura_prompt_executing" != ""
    then
        printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi
    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    __shura_prompt_executing=0
}

function +shura-pre-exec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf "\033]133;C;\007"
    __shura_prompt_executing=1
}

add-zsh-hook precmd +shura-pre-cmd
add-zsh-hook preexec +shura-pre-exec

bindkey '^U' backward-kill-line
bindkey '^K' kill-line

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

if is-command paru; then
    alias pacautoremove='paru -c'
elif is-command yay; then
    alias pacautoremove='yay -Ycc'
elif is-command pacman; then
    alias pacautoremove='sudo pacman -Rcns $(pacman -Qdtq)'
fi

if (( $+commands[wezterm] )); then
    eval "$(command wezterm shell-completion --shell zsh)"
fi

# vim: set ft=zsh sts=2 ts=2 sw=2 et:
