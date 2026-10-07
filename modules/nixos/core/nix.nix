{
  nix = {
    settings = {
      # 2 parallel builds x 6 cores = 12 threads total. "auto" + cores=0 ran
      # 12 builds that each grabbed all 12 threads, starving the desktop.
      max-jobs = 2;
      cores = 6;
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

    # Builds only get CPU/IO time the desktop isn't using.
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

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
