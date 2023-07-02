[ -d "${HOME}/.local/bin" ] && PATH="${PATH:+$PATH:}${HOME}/.local/bin"
[ -d "${HOME}/.composer/vendor/bin" ] && PATH="${PATH:+$PATH:}${HOME}/.composer/vendor/bin"

export PATH
