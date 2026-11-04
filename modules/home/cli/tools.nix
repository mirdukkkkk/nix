{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg

    file

    tcpdump
    tcpflow

    nur.repos.mirdukkkkk.molten
  ];
}
