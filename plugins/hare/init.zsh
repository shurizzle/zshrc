function {
  if os:is-windows; then
    return 0
  fi
  local p
  if os:is-linux; then
    p="/usr/src/hare"
  else
    p="/usr/local/src/hare"
  fi

  export HAREPATH="$p/stdlib:$p/third-party"
  export HARESRCDIR="${HOME}/.local/src/hare"
  export HAREPATH="${HAREPATH}:${HARESRCDIR}/third-party"
}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
