{ config, lib, pkgs, ... }:
let
    cfg = config.my.gaming;
in
{
    options.my.gaming.enable = lib.mkEnableOption "gaming (Steam, Proton, launchers)";

    config = lib.mkIf cfg.enable {
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
    };
}
