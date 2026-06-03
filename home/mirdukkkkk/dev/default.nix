{ pkgs, ... }:
{
    imports = [
        ./go.nix
        ./java.nix
        ./javascript.nix
        ./python.nix
    ];

    home.packages = with pkgs; [
        mongodb-compass
        sqlitebrowser
    ];
}