if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    set fish_greeting
    # fish_config theme save "Catppuccin Frappe"
    # Emulates vim's cursor shape behavior
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block
    starship init fish | source
    for file in ~/.config/fish/.{functions*,exports*,aliases*}
      if test -r $file
        source "$file"
      end
    end
end
