{
  nix = {
    settings = {
      max-jobs = "auto";
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      build-dir = "/nix/var/nix/builds";

      # extra-* append to the cache.nixos.org default instead of replacing it.
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      #trusted-users = [ "root" "mirdukkkkk" ];
    };

    optimise = {
      automatic = false;
      persistent = true;
      dates = "daily";
    };
  };

  # nh wraps nixos-rebuild (build tree, package diff, confirm prompt) and
  # replaces nix.gc: `nh clean` keeps a fixed number of generations and also
  # drops stale gcroots (old `result` links, direnv shells).
  programs.nh = {
    enable = true;
    clean = {
      enable = false;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
}
