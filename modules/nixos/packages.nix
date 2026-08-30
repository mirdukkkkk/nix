{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        wget
        curl

        e2fsprogs
        ntfs3g
        exfat

        rar
        unrar
        zip
        unzip
    ];
}
