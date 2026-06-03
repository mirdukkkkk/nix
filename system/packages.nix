{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        wget
        curl
        fastfetch

        wireshark
        compsize
        gparted
        vlc

        hunspell

        libreoffice
    ];
}
