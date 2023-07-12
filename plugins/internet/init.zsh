zmodload zsh/system
zmodload zsh/pcre

if is-command youtube-dl; then
  alias ytdl=youtube-dl
elif is-command yt-dlp; then
  alias ytdl=yt-dlp
fi

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr=
