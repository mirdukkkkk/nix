{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libfido2
    yubikey-manager
    opensc
    pcsc-tools
  ];
}
