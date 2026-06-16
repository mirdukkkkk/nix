{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        wget
        curl
        fastfetch

        wireshark
        compsize
        vlc

        hunspell

        libreoffice-qt
        #(pkgs.libreoffice.override {
        #    unwrapped = pkgs.libreoffice.unwrapped.override {
        #        withJava = false;
        #        kdeIntegration = true;
        #    };
        #})

        gparted
        e2fsprogs
        ntfs3g
        exfat
        smartmontools

        rar
        unrar
        zip
        unzip
    ];
}
