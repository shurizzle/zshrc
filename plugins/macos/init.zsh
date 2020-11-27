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
  function {
    local basepath="$1"
    local zfunction

    functions:add "$basepath"/functions/_brew

    setopt LOCAL_OPTIONS EXTENDED_GLOB BARE_GLOB_QUAL
    for zfunction ("$basepath"/functions/_brew/^([._]|README)*(.N:t))
      autoload -Uz -- "$zfunction"
  } "${0:h:a}"

  function {
    local formula
    local -a formulae
    local formula_fn

    zdefault -a ':zoppo:plugin:macos:brew:gnubin:formulae' \
      formulae formulae \
      \
      'coreutils' 'grep' 'gnu-tar' 'gnu-sed' 'gawk' 'make' 'openssl' \
      'curl-openssl' 'expat' 'qt' 'openblas' 'ruby' 'apr' 'icu4c' \
      'sqlite' 'libffi' 'openal-soft' 'util-linux' 'libpq' 'sphinx-doc' \
      'zlib'

    for formula in "${formulae[@]}"; do
      formula_fn="macos:brew:formula:$formula"
      is-function "$formula_fn" && "$formula_fn"
    done
  }
fi

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
