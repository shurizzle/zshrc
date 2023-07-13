plugins:load-if-enabled 'sudo'

if is-function sudo:dispatch; then
  is-command iotop && sudo:dispatch true iotop
  is-command powertop && sudo:dispatch true powertop
  is-command sg_raw && sudo:dispatch true sg_raw
  is-command partprobe && sudo:dispatch true partprobe
fi

# vim: set ft=zsh sts=2 ts=2 sw=2 et:
