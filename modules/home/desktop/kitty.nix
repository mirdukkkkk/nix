{
  programs.kitty = {
    enable = true;

    settings = {
      copy_on_select = "yes";

      # Trailing smear animation when the cursor moves/jumps, instead of
      # an instant teleport.
      cursor_trail = 1;
      cursor_trail_decay_fast = 0.1;
      cursor_trail_decay_slow = 0.3;
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
