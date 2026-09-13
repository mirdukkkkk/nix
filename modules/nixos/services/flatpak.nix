{ config, pkgs, ... }:
{
    services.flatpak = {
        enable = true;

        remotes = [
            { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
        ];
    };

    environment.plasma6.excludePackages = [ pkgs.kdePackages.flatpak-kcm ];

    systemd.services.flatpak-managed-install.unitConfig.OnSuccess = "flatpak-icon-cache-refresh.service";

    systemd.services.flatpak-icon-cache-refresh = {
        description = "Rebuild KDE app/icon cache (ksycoca) after flatpak changes";
        serviceConfig = {
            Type = "oneshot";
            User = "mirdukkkkk";
            ExecStart = pkgs.writeShellScript "flatpak-icon-cache-refresh" ''
                source ${config.system.build.setEnvironment}
                exec ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental
            '';
        };
    };
}
