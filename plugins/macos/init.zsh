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
    local basepath="$1"
    local zfunction

    zstyle ':zoppo:plugin:macos:brew' prefix "$(brew --prefix)"
    zstyle ':zoppo:plugin:macos:brew' caskroom "$(brew --caskroom)"

    functions:add "$basepath"/functions/_brew

    setopt LOCAL_OPTIONS EXTENDED_GLOB BARE_GLOB_QUAL
    for zfunction ("$basepath"/functions/_brew/^([._]|README)*(.N:t))
      autoload -Uz -- "$zfunction"
  } "${0:h:a}"

  macos:path:add-if-exists "/usr/local/bin"
  macos:path:add-if-exists "/usr/local/sbin"

  function {
    local installed
    eval "installed=($(brew ls -1 --formulae) $(brew ls -1 --casks))"
    zstyle ':zoppo:plugin:macos:brew' installed "${installed[@]}"
  }

  function {
    local formula
    local -a formulae
    local formula_fn

    zdefault -a ':zoppo:plugin:macos:brew:formulae' \
      formulae formulae \
      \
      'coreutils' 'grep' 'gnu-tar' 'gnu-sed' 'gawk' 'make' 'openssl' \
      'curl-openssl' 'expat' 'qt' 'openblas' 'ruby' 'apr' 'icu4c' \
      'sqlite' 'libffi' 'openal-soft' 'util-linux' 'libpq' 'sphinx-doc' \
      'zlib'

    for formula in "${formulae[@]}"; do
      formula_fn="macos:brew:formula:$formula"
      is-function "$formula_fn" && macos:brew:is-installed "$formula" && "$formula_fn"
    done
  }

  function {
    local cask
    local -a casks
    local cask_fn

    zdefault -a ':zoppo:plugin:macos:brew:casks' \
      casks casks \
      \
      'google-cloud-sdk'

    for cask in "${casks[@]}"; do
      cask_fn="macos:brew:cask:$cask"
      is-function "$cask_fn" && macos:brew:is-installed "$cask" && "$cask_fn"
    done
  }
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
