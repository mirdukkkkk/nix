{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg

    nur.repos.mirdukkkkk.molten
  ];
}
