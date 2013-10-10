zmodload zsh/sched || return 1

function init:cdvim {
  compdef _cd cdvim
  unfunction init:cdvim
}

hooks:add zoppo_postinit init:cdvim
