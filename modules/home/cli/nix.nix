{ config, lib, pkgs, ... }:
let
    cfg = config.my.cli.nix;
in
{
    options.my.cli.nix.flake = lib.mkOption {
        type = lib.types.str;
        default = "/etc/nixos";
        description = "The flake that the nrs and nrb aliases point at.";
    };

    config = {
        home.packages = with pkgs; [
            nixfmt
            nixd
            nil
        ];

        home.shellAliases = {
            nrs = "sudo nixos-rebuild switch --flake ${cfg.flake} -L";
            nrb = "sudo nixos-rebuild boot --flake ${cfg.flake} -L";

            nopt = "sudo nix store optimise";
            nclean = "sudo nix-collect-garbage -d";
        };

        programs.vscode.profiles.default = {
            extensions = with pkgs.vscode-extensions; [ bbenoist.nix ];
        };
    };
}
