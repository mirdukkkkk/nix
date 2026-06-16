{ pkgs, inputs, ... }:
{
    imports = [
        ./firefox

        ./discord.nix
        ./easyeffects.nix
        ./flameshot.nix
        ./kitty.nix
        ./mangohud.nix
        ./obs.nix
        ./psd.nix
        ./spotify.nix
        ./vscode.nix
    ];

    home.packages = with pkgs; [
        unstable.telegram-desktop
        pear-desktop
        qbittorrent

        aseprite
        tuxpaint
        gimp

        google-chrome

        inputs.iloader.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
