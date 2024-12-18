if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    # fish_config theme save "Catppuccin Frappe"
    # Emulates vim's cursor shape behavior
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block

    #  keybindings
    set -g fish_key_bindings fish_vi_key_bindings
    # Control + d
    bind \cd 'exit'


    starship init fish | source
    for file in ~/.config/fish/.{functions*,exports*,aliases*}
      if test -r $file
        source "$file"
      end
    end
end
