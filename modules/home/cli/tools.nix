{ pkgs, ... }:
{
    home.packages = with pkgs; [
        ffmpeg

        molten
    ];
}
