zmodload zsh/sched || return 1

function system:init:completion {
  compdef _cd cdvim
  compdef _mplayer mpv
  unfunction system:init:completion
}

hooks:add zoppo_postinit system:init:completion

sudo:dispatch true iotop
sudo:dispatch true powertop
sudo:dispatch true sg_raw
sudo:dispatch true partprobe
