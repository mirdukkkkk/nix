{ pkgs, ... }:
{
    home.shellAliases = {
        tree = "eza --tree";

        cat = "bat";

        top = "btm";

        #grep = "rg";
        #find = "fd";

        df = "duf";
        du = "dust";

        nrs = "sudo nixos-rebuild switch --flake /etc/nixos -L";
        nrb = "sudo nixos-rebuild boot --flake /etc/nixos -L";

        nopt = "sudo nix store optimise";
        nclean = "sudo nix-collect-garbage -d";
    };

    home.packages = with pkgs; [
        bat
        #ripgrep
        #fd
        duf
        dust
        bottom
    ];
}
