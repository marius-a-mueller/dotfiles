if [[ -d "$ZDOTDIR" ]]; then
  source "$ZDOTDIR/init.zsh"
  for file in "$ZDOTDIR"/*.zsh; do
    if [[ $file != "$ZDOTDIR"/init.zsh ]] && [[ $file != "$ZDOTDIR"/post.zsh ]] ; then
      source "$file"
    fi
  done
  source "$ZDOTDIR/post.zsh"
fi
