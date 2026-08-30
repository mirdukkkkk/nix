{
    imports = [
        ../../modules/home

        ./profile.nix
    ];

    home = {
        username = "mirdukkkkk";
        homeDirectory = "/home/mirdukkkkk";
        preferXdgDirectories = true;
        stateVersion = "25.11";
    };

    programs.home-manager.enable = true;
}
