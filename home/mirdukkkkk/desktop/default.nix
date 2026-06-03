{ pkgs, inputs, ... }:
{
    imports = [
        ./firefox

        ./discord.nix
        ./easyeffects.nix
        ./kitty.nix
        ./psd.nix
        ./spotify.nix
        ./vscode.nix
    ];

    home.packages = with pkgs; [
        telegram-desktop
        pear-desktop
        obs-studio
        qbittorrent

        aseprite
        tuxpaint
        gimp

        google-chrome

        #inputs.iloader.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
