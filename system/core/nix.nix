{
    nix = {
        settings = {
            max-jobs = "auto";
            auto-optimise-store = false;
            experimental-features = [ "nix-command" "flakes" ];
            #trusted-users = [ "root" "mirdukkkkk" ];
        };

        optimise = {
            automatic = false;
            persistent = true;
            dates = "daily";
        };

        gc = {
            automatic = false;
            persistent = true;
            dates = "daily";
            options = "--delete-older-than 3d";
        };
    };
}
