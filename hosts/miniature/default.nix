{
    imports = [
        ./filesystems.nix
        ./graphics.nix
        ./hardware.nix

        ../../system
    ];

    networking.hostName = "miniature";

    system.stateVersion = "25.11";
}
