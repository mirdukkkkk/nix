{ pkgs, ... }:
{
    services = {
        desktopManager.plasma6.enable = true;
        displayManager.plasma-login-manager.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        aurorae
        konsole
        elisa
        okular
        khelpcenter
        krdp
    ];

    environment.systemPackages = with pkgs.kdePackages; [
        #dolphin
        qtsvg
        filelight
        #ark
        #spectacle
        #gwenview
        #kate
        kolourpaint
        kdenlive
        #sddm-kcm
    ];
}
