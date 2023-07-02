[ -d "${HOME}/.local/bin" ] && PATH="${PATH:+$PATH:}${HOME}/.local/bin"
which npm 2>&1 >/dev/null && PATH="${PATH:+$PATH:}$(npm bin)"
[ -d "${HOME}/.composer/vendor/bin" ] && PATH="${PATH:+$PATH:}${HOME}/.composer/vendor/bin"
export NPM_PACKAGES="${HOME}/.npm-packages"
mkdir -p "${NPM_PACKAGES}/bin"
export PATH="${PATH:+$PATH:}:${NPM_PACKAGES}/bin"
export NODE_PATH="${NODE_PATH:+$NODE_PATH:}${NPM_PACKAGES}/lib/node_modules"

export PATH
