{
    imports = [
        ../../modules/nixos

        ./boot.nix
        ./filesystems.nix
        ./graphics.nix
        ./hardware.nix
        ./network.nix
        ./persistence.nix
        ./profile.nix
    ];

    networking.hostName = "miniature";

    system.stateVersion = "25.11";
}
