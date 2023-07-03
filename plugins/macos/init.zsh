if zdefault -t ':zoppo:plugin:macos:locale' enable 'yes'; then
  function {
    local encoding
    local -a languages
    local locale

    zdefault -s ':zoppo:plugin:macos:locale' encoding encoding 'UTF-8'
    macos:languages languages

    locale="$(macos:locale:best-match -e "$encoding" "${languages[@]}")"

    if [[ $? != 0 ]]; then
      locale=C
    fi

    export LANG="$locale"
  }
fi

if is-command brew && zdefault -t ':zoppo:plugin:macos:brew' enable 'yes'; then
  autoload -Uz regexp-replace

  function {
    setopt LOCAL_OPTIONS RE_MATCH_PCRE

    local x="$(brew shellenv)"
    regexp-replace x '(^|;|\n)(\s*)export(\s+)' '${match[1]}${match[2]}local${match[3]}'
    eval "$x"
    unset x

    zstyle ':zoppo:plugin:macos:brew' prefix      "$HOMEBREW_PREFIX"
    zstyle ':zoppo:plugin:macos:brew' cellar      "$HOMEBREW_CELLAR"
    zstyle ':zoppo:plugin:macos:brew' caskroom    "$HOMEBREW_PREFIX/Caskroom"
    zstyle ':zoppo:plugin:macos:brew' repository  "$HOMEBREW_REPOSITORY"
  }

  function {
    local prefix
    zstyle -s ':zoppo:plugin:macos:brew' prefix prefix

    export PATH="${prefix}/bin:${prefix}/sbin${PATH:+:$PATH}"
    export INFOPATH="${prefix}/share/info${INFOPATH:+:$INFOPATH}"
  }

  function {
    local basepath="$1"
    local zfunction

    functions:add "$basepath"/functions/_brew

    setopt LOCAL_OPTIONS EXTENDED_GLOB BARE_GLOB_QUAL
    for zfunction ("$basepath"/functions/_brew/^([._]|README)*(.N:t))
      autoload -Uz -- "$zfunction"
  } "${0:h:a}"

  +brew-postexec-installed
  +brew-postexec-formulae-exec
  +brew-postexec-casks-exec
  +brew-postexec-rehash

  typeset -ga brew_preexec_functions=()
  typeset -ga brew_postexec_functions=()

  add-brew-hook postexec +brew-postexec-rehash
  add-brew-hook postexec +brew-postexec-installed
  add-brew-hook postexec +brew-postexec-formulae-exec
  add-brew-hook postexec +brew-postexec-casks-exec
fi

if is-command docker-machine && zdefault -t ':zoppo:plugin:macos:docker-machine' enable 'yes'; then
  function {
    local def
    zdefault -s ':zoppo:plugin:macos:docker-machine' default def 'default'
    if [ -n "$(docker-machine ls --filter name="^$(regexp:escape "$def")\$" -f '{{.Name}}')" ]; then
      while [ "$(docker-machine status "$def")" != "Running" ]; do
        docker-machine start "$def"
      done

      while ! docker-machine ssh "$def" exit 0 &>/dev/null; do
        sleep 1
      done

      eval "$(docker-machine env "$def")"
    fi
  }
fi

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
