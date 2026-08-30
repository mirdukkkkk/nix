{
    imports = [
        # core
        ../../modules/nixos/core/ld.nix
        ../../modules/nixos/core/zram.nix

        # kernel
        ../../modules/nixos/kernel/tuning.nix

        # desktop
        ../../modules/nixos/desktop/fonts.nix
        ../../modules/nixos/desktop/media.nix
        ../../modules/nixos/desktop/office.nix
        ../../modules/nixos/desktop/plasma.nix
        ../../modules/nixos/desktop/sound.nix

        # services
        ../../modules/nixos/services/fstrim.nix
        ../../modules/nixos/services/lact.nix
        ../../modules/nixos/services/ratbagd.nix
        ../../modules/nixos/services/ssh.nix
        ../../modules/nixos/services/xray
    ];

    my = {
        system.zsh.enable = true;

        gaming.enable = true;

        services = {
            docker.enable = true;
            usbmuxd.enable = false;
        };
    };
}
