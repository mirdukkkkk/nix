{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.nix;
in
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

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

    # Prebuilt nix-index database instead of indexing nixpkgs locally: fish
    # suggests the package for an unknown command, `, <cmd>` runs it without
    # installing.
    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

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
