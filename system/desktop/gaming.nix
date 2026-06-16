{ pkgs, ... }:
{
    programs = {
        steam = {
            enable = true;
            remotePlay.openFirewall = true;
            extraCompatPackages = with pkgs.unstable; [
                proton-ge-bin
            ];
        };
        gamemode = {
            enable = true;
            enableRenice = true;
        };
    };

    environment.systemPackages = with pkgs; [
        heroic
        (prismlauncher.override {
            additionalPrograms = with pkgs; [ ffmpeg ];
            additionalLibs = with pkgs; [
                libpulseaudio
                alsa-lib

                mesa
                vulkan-loader
                libGL
                glfw

                dbus
                libdrm

                /*
                libx11
                libxext
                libxcursor
                libxrandr
                libxi
                libxcomposite
                libxdamage
                libxfixes
                libxcb
                libxshmfence
                */
                libxkbcommon
                wayland
            ];

            controllerSupport = false;
            gamemodeSupport = true;


            jdks = with pkgs; [
                javaPackages.compiler.temurin-bin.jre-25
                javaPackages.compiler.temurin-bin.jre-21
                javaPackages.compiler.temurin-bin.jre-17
                javaPackages.compiler.temurin-bin.jre-8
            ];
        })
    ];
}
