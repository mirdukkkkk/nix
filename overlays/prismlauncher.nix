final: prev:
{
    prismlauncher = prev.prismlauncher.override {
        additionalPrograms = with prev; [ ffmpeg ];
        additionalLibs = with prev; [
            libpulseaudio
            alsa-lib

            mesa
            vulkan-loader
            libGL
            glfw

            libxkbcommon
            wayland
        ];

        controllerSupport = false;
        gamemodeSupport = true;


        jdks = with prev; [
            javaPackages.compiler.temurin-bin.jre-25
            javaPackages.compiler.temurin-bin.jre-21
            javaPackages.compiler.temurin-bin.jre-17
            javaPackages.compiler.temurin-bin.jre-8
        ];
    };
}
