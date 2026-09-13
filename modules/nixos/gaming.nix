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

    boot.kernelModules = [ "ntsync" ];

    services.flatpak.packages = [
        "ru.linux_gaming.PortProton"
    ];

    environment.systemPackages = with pkgs; [
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

            jdks = with pkgs.javaPackages.compiler.temurin-bin; [
                jre-25
                jre-21
                jre-17
                jre-8
            ];
        })
    ];
}
