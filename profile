[ -d "${HOME}/.local/bin" ] && PATH="${PATH:+$PATH:}${HOME}/.local/bin"
[ -d "${HOME}/.composer/vendor/bin" ] && PATH="${PATH:+$PATH:}${HOME}/.composer/vendor/bin"

export PATH

# vim: set ft=zsh sts=2 ts=2 sw=2 et:
