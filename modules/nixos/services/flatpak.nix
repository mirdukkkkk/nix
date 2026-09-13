{ pkgs, ... }:
{
    services.flatpak = {
        enable = true;

        remotes = [
            { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
        ];
    };

    environment.plasma6.excludePackages = [ pkgs.kdePackages.flatpak-kcm ];
}
