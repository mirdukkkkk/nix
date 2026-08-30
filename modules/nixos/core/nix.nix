{
    nix = {
        settings = {
            max-jobs = "auto";
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];

            build-dir = "/nix/var/nix/builds";

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
