{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.photocraft
    aseprite
    gimp
  ];
}
