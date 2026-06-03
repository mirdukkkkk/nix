{
    programs.zsh.shellAliases = {
        ls = "eza --icons";
        ll = "eza -lh --icons --git";
        tree = "eza --tree --icons";

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

        fastfetch = "hyfetch";
    };
}
