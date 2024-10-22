source "$ZDOTDIR/init.zsh"
FILES_STR=$(fd --glob '*.zsh' --exclude 'init.zsh' --exclude 'post.zsh' "$ZDOTDIR")

FILES=($(echo $FILES_STR | tr '\n' ' '))

if [[ -d "$ZDOTDIR" ]]; then
  for file in "$ZDOTDIR"/*.zsh; do
    source "$file"
  done
fi

source "$ZDOTDIR/post.zsh"
