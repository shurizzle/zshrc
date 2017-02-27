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
sudo:dispatch true sg_raw
sudo:dispatch true partprobe

[ -f "$HOME/.homebrewrc" ] && . "$HOME/.homebrewrc"

if [ -d /usr/local/m-cli ]; then
  export PATH="$PATH:/usr/local/m-cli"
fi
