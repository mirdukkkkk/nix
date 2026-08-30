{ pkgs, ... }:
{
    services = {
        desktopManager.plasma6.enable = true;
        displayManager.plasma-login-manager.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        aurorae
        spectacle
        konsole
        kwin-x11
        elisa
        okular
        khelpcenter
        krdp
    ];

    environment.systemPackages = with pkgs.kdePackages; [
        qtsvg
        filelight
        kolourpaint
        kdenlive
    ];
}
