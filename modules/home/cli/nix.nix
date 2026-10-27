{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.nix;
in
{
  options.my.cli.nix.flake = lib.mkOption {
    type = lib.types.str;
    default = "/etc/nixos";
    description = "The flake that nh operates on (exported as NH_FLAKE).";
  };

  config = {
    home.packages = with pkgs; [
      nixfmt
      nixd
      nil
    ];

    # Lets `nh os switch` and friends run without a flake path argument.
    home.sessionVariables.NH_FLAKE = cfg.flake;

    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        jnoortheen.nix-ide
      ];

      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "nixfmt";

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.tabSize" = 2;
        };
      };
    };
  };
}
