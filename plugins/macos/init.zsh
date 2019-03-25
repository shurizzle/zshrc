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

if zdefault -t ':zoppo:plugin:macos:brew' enable 'yes'; then
    function {
        local formula
        local -a formulae
        local formula_fn

        zdefault -a ':zoppo:plugin:macos:brew:gnubin:formulae' \
            formulae formulae \
            \
            'coreutils' 'grep' 'gnu-tar' 'gnu-sed' 'gawk' 'make' 'openssl' \
            'curl-openssl' 'expat' 'qt' 'openblas' 'ruby'

        for formula in "${formulae[@]}"; do
            formula_fn="macos:brew:formula:$formula"
            is-function "$formula_fn" && "$formula_fn"
        done
    }
fi
