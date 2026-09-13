{
  programs.kitty = {
    enable = true;

    settings = {
      copy_on_select = "yes";
    };

    keybindings = {
      "ctrl+c" = "copy_and_clear_or_interrupt";
      # ctrl+v deliberately left unbound: kitty would swallow it at the
      # terminal layer, so programs needing raw ^V (vim visual-block,
      # readline literal-insert) never see it. Paste via shift+insert
      # or kitty's default ctrl+shift+v instead.
      "shift+insert" = "paste_from_clipboard";
    };
  };
}
