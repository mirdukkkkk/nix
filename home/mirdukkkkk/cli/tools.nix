{ pkgs, ... }:
{
    home.packages = with pkgs; [
        ffmpeg

        protonup-qt

        amdgpu_top
        htop
        btop
    ];
}
