{
    programs.kitty = {
        enable = true;

        extraConfig = ''
            map ctrl+c copy_and_clear_or_interrupt
            map ctrl+v paste_from_clipboard
            map shift+insert paste_from_clipboard
            copy_on_select yes
        '';
    };
}
