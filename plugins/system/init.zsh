zmodload zsh/sched || return 1

function system:init:completion {
  compdef _cd cdvim
  compdef _mplayer mpv
  . /home/shura/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
  unfunction system:init:completion
}

hooks:add zoppo_postinit system:init:completion

sudo:dispatch true iotop
sudo:dispatch true powertop
