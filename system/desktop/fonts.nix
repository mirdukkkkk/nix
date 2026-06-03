{ pkgs, ... }:
{
    fonts.packages = with pkgs; [
        jetbrains-mono
        noto-fonts
        comic-relief
        corefonts
        montserrat
    ];
}