source "$ZDOTDIR/init.zsh"
FILES_STR=$(find "$ZDOTDIR" -name "*.zsh"  -not -name "init.zsh" -not -name "post.zsh")

FILES=($(echo $FILES_STR | tr '\n' ' '))

if [[ -d "$ZDOTDIR" ]]; then
  for file in "$ZDOTDIR"/*.zsh; do
    source "$file"
  done
fi

source "$ZDOTDIR/post.zsh"
