{
  programs.plasma.window-rules = [
    {
      description = "CS2 Fullscreen";

      match = {
        window-class = {
          value = "cs2";
          type = "exact";
        };
        window-types = [ "normal" ];
      };

      apply = {
        fullscreen = {
          value = true;
          apply = "force";
        };
        noborder = {
          value = true;
          apply = "initially";
        };
        blockcompositing = {
          value = true;
          apply = "initially";
        };
        screen = {
          value = 0;
          apply = "force";
        };
      };
    }
  ];
}
