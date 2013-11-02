zmodload zsh/sched || return 1

function system:init:completion {
  compdef _cd cdvim
  compdef _mplayer mpv
  unfunction system:init:completion
}

hooks:add zoppo_postinit system:init:completion
