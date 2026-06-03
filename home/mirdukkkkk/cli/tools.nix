{ pkgs, ... }:
{
    home.packages = with pkgs; [
        gh
        github-desktop
        ffmpeg

        protonup-qt

        eza
        bat
        ripgrep
        fd
        procs
        duf
        dust
        bottom
        delta

        hyfetch
        fastfetch
        amdgpu_top
        htop
        btop
    ];
}
