{ pkgs, ... }:
{
    programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
            pixel-art
            input-overlay

            obs-vaapi
            obs-gstreamer
            obs-vkcapture
            obs-pipewire-audio-capture
        ];
    };
}
